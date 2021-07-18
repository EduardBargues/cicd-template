using System;
using System.Threading.Tasks;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Net.Http;
using System.Diagnostics;
using Newtonsoft.Json;

namespace Performance.Tests.Console
{
    class Program
    {
        const string appFile = "./tests/app.json";
        const string resultFile = "./tests/performance/result.json";
        static async Task Main(string[] args)
        {
            int numberOfThreads = 5;
            int numberOfSeconds = 10;
            var configJson = File.ReadAllText(appFile);
            var config = JsonConvert.DeserializeObject<App>(configJson);
            string url = $"{config.Base_Url.Value}/{config.Diagnostics_Endpoint.Value}";//"https://r18ajbffd0.execute-api.eu-west-1.amazonaws.com/dev/diagnostics";

            double averageResponseTime = await Go(numberOfThreads, numberOfSeconds, url);
            string json = JsonConvert.SerializeObject(new FinalResult() { AverageResponseTime = averageResponseTime });
            File.WriteAllText(resultFile, json);
        }

        public static async Task<double> Go(int numberOfThreads, int numberOfSeconds, string url)
        {
            IEnumerable<Task<Result>> tasks = Enumerable.Range(1, numberOfThreads)
                .Select(threadId => CallDiagnosticsEndpoint(threadId, numberOfSeconds, url));
            Result[] results = await Task.WhenAll(tasks);

            return results
                .SelectMany(result => result.ResponseTimes)
                .Average();
        }

        public static async Task<Result> CallDiagnosticsEndpoint(int threadId, int numberOfSeconds, string url)
        {
            Result result = new Result() { ThreadId = threadId };
            HttpClient client = new HttpClient();
            Stopwatch watch = new Stopwatch();
            DateTime end = DateTime.Now.AddSeconds(numberOfSeconds);
            while (DateTime.Now < end)
            {
                watch.Start();
                await client.GetAsync(url);
                watch.Stop();
                result.ResponseTimes.Add(watch.ElapsedMilliseconds);
                System.Console.WriteLine($"RESPONSE TIME [milliseconds]: {watch.ElapsedMilliseconds}");
                watch.Reset();
            }

            return result;
        }
    }

    class App
    {
        public ValueClass Base_Url { get; set; }
        public ValueClass Diagnostics_Endpoint { get; set; }
    }
    class ValueClass
    {
        public string Value { get; set; }
    }
    class Result
    {
        public int ThreadId { get; set; }
        public List<long> ResponseTimes { get; set; } = new List<long>();
    }
    class FinalResult
    {
        public double AverageResponseTime { get; set; }
    }
}
