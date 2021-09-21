using System.Threading.Tasks;

namespace Service
{
    public class DependencyService : IDependencyService
    {
        public static IDependencyService CreateInstance() => new DependencyService();

        public Task<string> DoAsync()
        {
            return Task.FromResult("dependency-injection-service");
        }
    }
}
