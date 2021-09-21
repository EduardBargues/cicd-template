using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using WebApi;
using Xunit;
using System.Threading.Tasks;
using System;
using System.Net;

namespace Tests
{
    public class WebApiTests : IClassFixture<WebApplicationFactory<Startup>>
    {
        private readonly WebApplicationFactory<Startup> _factory;

        public WebApiTests(WebApplicationFactory<Startup> factory)
        {
            _factory = factory ?? throw new ArgumentNullException(nameof(factory));
        }

        [Fact]
        public async Task Diagnostics()
        {
            // ARRANGE
            const HttpStatusCode expectedStatusCode = HttpStatusCode.OK;
            var client = _factory.CreateClient();

            // ACT
            var response = await client.GetAsync("dotnet-webapi");

            // ASSERT
            Assert.NotNull(response);
            Assert.Equal(expectedStatusCode, response.StatusCode);
        }
    }
}
