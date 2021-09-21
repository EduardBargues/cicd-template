using System.Collections.Generic;
using System.Net;

using Amazon.Lambda.Core;
using Amazon.Lambda.APIGatewayEvents;
using Service;
using System.Threading.Tasks;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace Function
{
    public class Function
    {
        private readonly IDependencyService _service;

        public Function() : this(DependencyService.CreateInstance()) { }
        public Function(IDependencyService service)
        {
            _service = service;
        }

        public async Task<APIGatewayProxyResponse> FunctionHandler(APIGatewayProxyRequest request, ILambdaContext context)
        {
            context?.Logger?.Log($@"DOTNET-FUNCTION LAMBDA EXECUTION
    request-id: {request?.RequestContext?.RequestId}
    aws-request-id: {context?.AwsRequestId}");

            var dependencyResponse = await _service.DoAsync();
            var response = new APIGatewayProxyResponse
            {
                StatusCode = (int)HttpStatusCode.OK,
                Body = $"dotnet-function-lambda {dependencyResponse}",
                Headers = new Dictionary<string, string> { { "Content-Type", "text/plain" } }
            };

            return response;
        }
    }
}
