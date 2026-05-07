---
title: "Building AI Agents for Automated Trading Systems Using .NET C# Semantic Kernel, Azure AI Services, and Azure Functions"
url: "https://dev.to/paulotorrestech/building-ai-agents-for-automated-trading-systems-using-net-c-semantic-kernel-azure-ai-services-iml"
author: "Paulo Torres"
category: "ai-agents"
---

# Building AI Agents for Automated Trading Systems Using .NET C# Semantic Kernel, Azure AI Services, and Azure Functions

**Author:** Paulo Torres
**Date Published:** January 7, 2025

## Article Overview

This comprehensive guide explores constructing an AI-powered trading agent leveraging ".NET C# Semantic Kernel, .NET Core C# 8, ASP.NET Core Web API, Azure AI Services, Azure Functions, Azure Key Vault, Azure Cosmos DB (MongoDB API), and Azure Kubernetes Service (AKS)."

## Key Sections & Code Examples

### Development Environment Setup

Prerequisites include Visual Studio 2022, .NET Core SDK, Python 3.8+, Azure CLI, and Docker Desktop.

**Install Semantic Kernel:**
```bash
git clone https://github.com/microsoft/semantic-kernel.git
```

**Python Libraries Installation:**
```bash
pip install pandas numpy scikit-learn joblib azureml-sdk
```

### Python AI Model Development

**train_model.py:**
```python
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
import joblib
from azureml.core import Workspace, Dataset

# Connect to Azure ML Workspace
ws = Workspace.from_config()

# Load Dataset
dataset = Dataset.get_by_name(ws, name='historical_stock_data')
df = dataset.to_pandas_dataframe()

# Data Preprocessing
# ... (cleaning, feature engineering)

# Split Data
X = df.drop('target', axis=1)
y = df['target']

# Train Model
model = RandomForestClassifier(n_estimators=100)
model.fit(X, y)

# Save Model
joblib.dump(model, 'model.joblib')
```

**Register Model in Azure ML:**
```python
from azureml.core.model import Model

model = Model.register(workspace=ws,
                       model_path='model.joblib',
                       model_name='TradingAIModel')
```

### Semantic Kernel Integration

**Install NuGet Package:**
```bash
dotnet add package Microsoft.SemanticKernel
```

**TradingAgentKernel.cs:**
```csharp
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.Orchestration;
using Microsoft.SemanticKernel.SkillDefinition;

public class TradingAgentKernel
{
    private readonly IKernel _kernel;

    public TradingAgentKernel()
    {
        _kernel = Kernel.Builder.Build();

        // Register AI skills or functions
        _kernel.RegisterSemanticFunction("PredictMarketTrend", PredictMarketTrend);
    }

    [SKFunction]
    public async Task<SKContext> PredictMarketTrend(SKContext context)
    {
        // Implement logic to call the AI model
        var features = context.Variables["features"];
        var prediction = await CallAIModelAsync(features);
        context.Variables["prediction"] = prediction.ToString();
        return context;
    }

    private async Task<int> CallAIModelAsync(string features)
    {
        // Logic to call the AI model (e.g., via REST API)
        // ...
        return prediction;
    }

    public async Task<string> ExecuteAsync(string input)
    {
        var context = await _kernel.RunAsync(input, "PredictMarketTrend");
        return context.Variables["prediction"];
    }
}
```

### .NET Core Web API Setup

**Initialize Project:**
```bash
dotnet new webapi -n TradingAIAPI
cd TradingAIAPI
```

**Install NuGet Packages:**
```bash
dotnet add package Microsoft.Azure.Cosmos
dotnet add package Azure.Security.KeyVault.Secrets
dotnet add package Azure.Extensions.AspNetCore.Configuration.Secrets
dotnet add package Azure.Identity
dotnet add package Microsoft.SemanticKernel
```

**appsettings.json:**
```json
{
  "Azure": {
    "KeyVault": "https://your-keyvault-name.vault.azure.net/",
    "CosmosDb": {
      "Endpoint": "your-cosmosdb-endpoint",
      "Database": "TradingDB",
      "Container": "Trades"
    }
  }
}
```

### API Controller Implementation

**TradesController.cs:**
```csharp
[ApiController]
[Route("[controller]")]
public class TradesController : ControllerBase
{
    private readonly TradingAgentKernel _tradingAgentKernel;
    private readonly TradeRepository _tradeRepository;

    public TradesController(TradingAgentKernel tradingAgentKernel, TradeRepository tradeRepository)
    {
        _tradingAgentKernel = tradingAgentKernel;
        _tradeRepository = tradeRepository;
    }

    [HttpPost("execute")]
    public async Task<IActionResult> ExecuteTrade([FromBody] TradeRequest request)
    {
        // Use Semantic Kernel to get prediction
        var prediction = await _tradingAgentKernel.ExecuteAsync(request.FeaturesJson);

        if (int.Parse(prediction) == 1)
        {
            // Logic to execute buy order
            await _tradeRepository.AddTradeAsync(new Trade
            {
                Symbol = request.Symbol,
                Price = request.Price,
                Timestamp = DateTime.UtcNow,
                Action = "Buy"
            });
        }
        else
        {
            // Logic to execute sell order
            await _tradeRepository.AddTradeAsync(new Trade
            {
                Symbol = request.Symbol,
                Price = request.Price,
                Timestamp = DateTime.UtcNow,
                Action = "Sell"
            });
        }

        return Ok(new { Success = true });
    }
}
```

**TradeRequest Model:**
```csharp
public class TradeRequest
{
    public string Symbol { get; set; }
    public double Price { get; set; }
    public string FeaturesJson { get; set; } // JSON string of features
}
```

### Azure Key Vault Configuration

**Create Key Vault:**
```bash
az keyvault create --name TradingAIKeyVault --resource-group TradingAI_RG --location eastus
```

**Store Secret:**
```bash
az keyvault secret set --vault-name TradingAIKeyVault --name "CosmosDbConnectionString" --value "your-connection-string"
```

**Program.cs Configuration:**
```csharp
using Azure.Identity;

public class Program
{
    public static void Main(string[] args)
    {
        var host = CreateHostBuilder(args).Build();
        host.Run();
    }

    public static IHostBuilder CreateHostBuilder(string[] args) =>
        Host.CreateDefaultBuilder(args)
            .ConfigureAppConfiguration((context, config) =>
            {
                var builtConfig = config.Build();
                var keyVaultName = builtConfig["Azure:KeyVault"];
                if (!string.IsNullOrEmpty(keyVaultName))
                {
                    var keyVaultUri = new Uri(keyVaultName);
                    config.AddAzureKeyVault(keyVaultUri, new DefaultAzureCredential());
                }
            })
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<Startup>();
            });
}
```

### Azure Functions Implementation

**Create Function Project:**
```bash
func init TradingAIFunctions --dotnet
cd TradingAIFunctions
func new --name MarketDataIngestion --template "HttpTrigger" --authlevel "Function"
```

**MarketDataIngestion.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

public static class MarketDataIngestion
{
    [FunctionName("MarketDataIngestion")]
    public static async Task<IActionResult> Run(
        [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
        ILogger log)
    {
        // Parse incoming market data
        var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var marketData = JsonConvert.DeserializeObject<MarketData>(requestBody);

        // Logic to process data or trigger trading actions
        // ...

        return new OkResult();
    }
}

public class MarketData
{
    public string Symbol { get; set; }
    public double Price { get; set; }
    // Other relevant fields
}
```

**Deploy Function:**
```bash
func azure functionapp publish TradingAIFunctionsApp
```

### Docker Containerization

**Dockerfile:**
```dockerfile
# Base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

# Copy files and build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["TradingAIAPI.csproj", "./"]
RUN dotnet restore "./TradingAIAPI.csproj"
COPY . .
RUN dotnet build "TradingAIAPI.csproj" -c Release -o /app/build

# Publish
FROM build AS publish
RUN dotnet publish "TradingAIAPI.csproj" -c Release -o /app/publish

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TradingAIAPI.dll"]
```

### Azure Kubernetes Service Deployment

Create Machine Learning resource group:
```bash
az group create --name TradingAI_RG --location eastus
```

### Monitoring with Application Insights

**Install Package:**
```bash
dotnet add package Microsoft.ApplicationInsights.AspNetCore
```

**Startup Configuration:**
```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddApplicationInsightsTelemetry("Your_Instrumentation_Key");
    services.AddControllers();
}
```

**Enable Azure Monitor:**
```bash
az aks enable-addons -a monitoring -n TradingAICluster -g TradingAI_RG
```

## Key Takeaways

- The Semantic Kernel library integrates AI capabilities into .NET applications, enabling autonomous decision-making in trading systems
- Azure services provide enterprise-grade infrastructure for secure, scalable trading agent deployment
- Event-driven architecture via Azure Functions enables real-time data processing
- Docker and Kubernetes enable containerized deployment and horizontal scaling
- Key Vault manages sensitive credentials securely throughout the application lifecycle
- Python models integrate with .NET applications via REST APIs and Azure Machine Learning
- Comprehensive monitoring through Application Insights ensures operational visibility

## About the Author

Paulo Torres is a Senior Software Engineer and Senior AI Engineer specializing in ".NET C#, Azure, and AI" solutions with 22 years of experience building innovative software systems.
