using System;
using System.Threading.Tasks;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Net.Http;
using System.Diagnostics;
using Newtonsoft.Json;

namespace Deployment.Monitoring.Tests.Console
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var deploymentStart = DateTime.Now;
            string appFile = args[0];
            var app = JsonConvert.DeserializeObject<App>(File.ReadAllText(appFile));

            var numberOfSeconds = int.Parse(args[1]);

            await Go(app, numberOfSeconds, deploymentStart);
        }

        public static async Task Go(App app, int numberOfSeconds, DateTime deploymentStart)
        {
            var tasks = app.Endpoints.Value.Keys
                .Select(endpointName => MonitorEndpoint($"{app.Base_Url.Value}/{app.Endpoints.Value[endpointName]}", numberOfSeconds, deploymentStart));
            var aggregatedItems = await Task.WhenAll(tasks);
            var itemsGroupedByUrl = aggregatedItems.SelectMany(ts => ts).GroupBy(item => item.Url);
            foreach (var group in itemsGroupedByUrl)
            {
                WriteReport(group);
            }
        }
        public static void WriteReport(IGrouping<string, Item> group)
        {
            var items = group.ToList();
            var responseTimes = items.Select(item => item.ResponseTime).OrderBy(responseTime => responseTime).ToList();
            var maxResponseTime = responseTimes.Max();
            var averageResponseTime = responseTimes.Average();
            var stdDev = StdDev(responseTimes);
            var anyFailure = items.Any(item => item.StatusCode != 200) ? "YES" : "NO";
            var percentiles = new List<double>() { 0.9, 0.95, 0.99, 0.999, 0.9999 }
                .Select(percentile => (percentile, GetPercentile(percentile, responseTimes)))
                .ToDictionary(pair => pair.Item1, pair => pair.Item2);

            System.Console.WriteLine($"    ----- -----");
            System.Console.WriteLine($"    url: {group.Key}");
            System.Console.WriteLine($"    downtime?: {anyFailure}");
            System.Console.WriteLine($"    maximum-response-time: {maxResponseTime}");
            System.Console.WriteLine($"    average-response-time: {averageResponseTime}");
            System.Console.WriteLine($"    standard-deviation-response-time: {stdDev}");
            foreach (var percentilePair in percentiles)
            {
                System.Console.WriteLine($"    percentile-response-time {percentilePair.Key.ToString("P")}: {percentilePair.Value}");
            }
        }

        public static double GetPercentile(double percentile, List<long> responseTimes)
        {
            var count = responseTimes.Count();
            return responseTimes.Where((responseTime, index) => index <= count * percentile).Max();
        }

        public static double StdDev(List<long> values)
        {
            double ret = 0;
            int count = values.Count();
            if (count > 1)
            {
                double avg = values.Average();
                double sum = values.Sum(d => (d - avg) * (d - avg));
                ret = Math.Sqrt(sum / count);
            }
            return ret;
        }

        public static async Task<List<Item>> MonitorEndpoint(string url, int numberOfSeconds, DateTime deploymentStart)
        {
            var items = new List<Item>();
            Stopwatch watch = new Stopwatch();
            using (HttpClient client = new HttpClient())
            {
                DateTime end = DateTime.Now.AddSeconds(numberOfSeconds);
                while (DateTime.Now < end)
                {
                    var item = new Item();
                    item.Url = url;
                    item.Time = (DateTime.Now - deploymentStart).Milliseconds;

                    watch.Start();
                    var response = await client.GetAsync(url);
                    watch.Stop();

                    item.ResponseTime = watch.ElapsedMilliseconds;
                    item.StatusCode = (int)response.StatusCode;

                    items.Add(item);
                    watch.Reset();
                }
            }

            return items;
        }
    }

    class App
    {
        public ValueClass<string> Base_Url { get; set; }
        public ValueClass<Dictionary<string, string>> Endpoints { get; set; }
    }
    class ValueClass<T>
    {
        public T Value { get; set; }
    }

    class Item
    {
        public string Url { get; set; }
        public int StatusCode { get; set; }
        public long Time { get; set; }
        public long ResponseTime { get; set; }
    }
}
