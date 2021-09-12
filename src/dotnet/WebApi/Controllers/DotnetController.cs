using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Function;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace WebApi.Controllers
{
    [ApiController]
    public class DotnetController : ControllerBase
    {
        private readonly ILogger<DotnetController> _logger;
        private readonly IFunction _function;

        public DotnetController(ILogger<DotnetController> logger, IFunction function)
        {
            _logger = logger;
            _function = function;
        }

        [HttpGet("dotnet-webapi")]
        public IActionResult Get()
        {
            var request = (APIGatewayProxyRequest)HttpContext.Items["LambdaRequestObject"];
            var context = (ILambdaContext)HttpContext.Items["LambdaContext"];
            _logger.LogInformation($@"DOTNET-WEBAPI LAMBDA EXECUTION
    request-id: {request?.RequestContext?.RequestId}
    aws-request-id: {context?.AwsRequestId}");

            var functionResponse = _function.FunctionHandler(request, context);
            var result = new ObjectResult(functionResponse.Body)
            {
                StatusCode = functionResponse.StatusCode,
            };

            return result;
        }
    }
}
