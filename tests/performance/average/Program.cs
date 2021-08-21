using System;
using System.Threading.Tasks;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Net.Http;
using System.Diagnostics;
using Newtonsoft.Json;

namespace Performance.Average.Tests.Console
{
    class Program
    {
        static async Task Main(string[] args)
        {
            double maxAverageResponseTime = double.Parse(args[0]);
            int threads = int.Parse(args[1]);
            int seconds = int.Parse(args[2]);
            string baseUrl = args[3];
            string endpoint = args[4];
            string url = $"{baseUrl}/{endpoint}";

            double averageResponseTime = await Go(threads, seconds, url);
            System.Console.WriteLine($"    average-response-time [milliseconds]: {averageResponseTime}");
            double score = (maxAverageResponseTime - averageResponseTime) / maxAverageResponseTime;
            System.Console.WriteLine($"    score [0->1]: {score}");
            if (averageResponseTime > maxAverageResponseTime)
            {
                string message = "ERROR => MAXIMUM AVERAGE RESPONSE TIME EXCEEDED!";
                throw new Exception(message);
            }
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
            DateTime end = DateTime.Now.AddSeconds(numberOfSeconds);
            Stopwatch watch = new Stopwatch();
            using (HttpClient client = new HttpClient())
            {
                while (DateTime.Now < end)
                {
                    watch.Start();
                    await client.GetAsync(url);
                    watch.Stop();
                    result.ResponseTimes.Add(watch.ElapsedMilliseconds);
                    watch.Reset();
                }
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
