using System.Threading.Tasks;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Service;

namespace WebApi.Controllers
{
    [ApiController]
    public class Controller : ControllerBase
    {
        private readonly ILogger<Controller> _logger;
        private readonly IDependencyService _service;

        public Controller(ILogger<Controller> logger, IDependencyService service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet("dotnet-webapi")]
        public async Task<IActionResult> Get()
        {
            var request = (APIGatewayProxyRequest)HttpContext.Items["LambdaRequestObject"];
            var context = (ILambdaContext)HttpContext.Items["LambdaContext"];
            _logger.LogInformation($@"DOTNET-WEBAPI LAMBDA EXECUTION
    request-id: {request?.RequestContext?.RequestId}
    aws-request-id: {context?.AwsRequestId}");

            var dependencyResponse = await _service.DoAsync();

            return Ok($"dotnet-webapi + {dependencyResponse}");
        }
    }
}
