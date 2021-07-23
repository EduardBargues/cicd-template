using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DotnetController : ControllerBase
    {
        private readonly ILogger<DotnetController> _logger;

        public DotnetController(ILogger<DotnetController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Get()
        {
            _logger.LogInformation($"REQUEST RECEIVED AT [UTC]({DateTime.UtcNow})");
            return Ok("dotnet-ok");
        }
    }
}
