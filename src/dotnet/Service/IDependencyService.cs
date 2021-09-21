using System;
using System.Threading.Tasks;

namespace Service
{
    public interface IDependencyService
    {
        Task<string> DoAsync();
    }
}
