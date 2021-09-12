using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

using Amazon.Lambda.Core;
using Amazon.Lambda.APIGatewayEvents;

namespace Function
{
    public interface IFunction
    {
        APIGatewayProxyResponse FunctionHandler(APIGatewayProxyRequest request, ILambdaContext context);
    }
}
