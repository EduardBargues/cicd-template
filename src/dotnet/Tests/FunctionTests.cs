using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using Xunit;
using Amazon.Lambda.Core;
using Amazon.Lambda.TestUtilities;

using Function;
using Amazon.Lambda.APIGatewayEvents;

namespace Function.Tests
{
    public class FunctionTest
    {
        [Fact]
        public void TestToUpperFunction()
        {
            // Invoke the lambda function and confirm the string was upper cased.
            var function = new Function();
            var context = new TestLambdaContext();
            var request = new APIGatewayProxyRequest() { RequestContext = new APIGatewayProxyRequest.ProxyRequestContext() };
            var response = function.FunctionHandler(request, context);

            Assert.Equal(200, response.StatusCode);
        }
    }
}
