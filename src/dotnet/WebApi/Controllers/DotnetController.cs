using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace WebApi.Controllers
{
    [ApiController]
    public class DotnetController : ControllerBase
    {
        private readonly ILogger<DotnetController> _logger;

        public DotnetController(ILogger<DotnetController> logger)
        {
            _logger = logger;
        }

        [HttpGet("dotnet-webapi")]
        public IActionResult Get()
        {
            var request = (APIGatewayProxyRequest)HttpContext.Items["LambdaRequestObject"];
            var context = (ILambdaContext)HttpContext.Items["LambdaContext"];
            _logger.LogInformation($@"DOTNET-FUNCTION LAMBDA EXECUTION
    request-id: {request?.RequestContext?.RequestId}
    aws-request-id: {context?.AwsRequestId}");

            return Ok("dotnet-webapi");
        }
    }
}
