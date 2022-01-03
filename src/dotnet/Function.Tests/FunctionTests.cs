using System.Threading.Tasks;

using Xunit;
using Amazon.Lambda.TestUtilities;
using Amazon.Lambda.APIGatewayEvents;
using Service;
using Moq;

namespace Function.Tests
{
    public class FunctionTest
    {
        [Fact]
        public async Task TestToUpperFunction()
        {
            // ARRANGE
            var mockResponse = "mamock :P !";
            var mock = new Mock<IDependencyService>();
            mock.Setup(m => m.DoAsync()).ReturnsAsync(mockResponse);
            var function = new Function(mock.Object);
            var context = new TestLambdaContext();
            var request = new APIGatewayProxyRequest() { RequestContext = new APIGatewayProxyRequest.ProxyRequestContext() };

            // ACT
            var response = await function.FunctionHandler(request, context);

            // ASSERT
            Assert.Equal(200, response.StatusCode);
            Assert.Contains(mockResponse, response.Body);
        }
    }
}
