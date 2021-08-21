using System;
using System.Threading.Tasks;
using System.IO;
using System.Collections.Generic;
using System.Net.Http;
using System.Diagnostics;

namespace Performance.FirstCall.Tests.Console
{
    class Program
    {
        static async Task Main(string[] args)
        {
            double maxResponseTime = double.Parse(args[0]);
            string baseUrl = args[1];
            string endpoint = args[2];
            string url = $"{baseUrl}/{endpoint}";

            double responseTime = await Call(url);
            System.Console.WriteLine($"    average-response-time [milliseconds]: {responseTime}");
            double score = (maxResponseTime - responseTime) / maxResponseTime;
            System.Console.WriteLine($"    score [0->1]: {score}");
            if (responseTime > maxResponseTime)
            {
                string message = "ERROR => MAXIMUM AVERAGE RESPONSE TIME EXCEEDED!";
                throw new Exception(message);
            }
        }

        public static async Task<long> Call(string url)
        {
            long result = 0;
            Stopwatch watch = new Stopwatch();
            using (HttpClient client = new HttpClient())
            {
                watch.Start();
                await client.GetAsync(url);
                watch.Stop();
                result = watch.ElapsedMilliseconds;
            }
            return result;
        }
    }
}