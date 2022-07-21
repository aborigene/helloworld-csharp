// Copyright 2022 Google Inc.
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text.Json;
using System.Threading.Tasks;
using System.IO;
using System.Text;
using System.Diagnostics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using OpenTelemetry.Exporter;

//#using System.Net.Http.Headers;
//#using System.Threading.Tasks;

var serviceName = "Dynatrace.GCPCloudRun.HelloWorld"+Environment.GetEnvironmentVariable("AMBIENTE");
var serviceVersion = "0.0.1";

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenTelemetryTracing(b =>
{
    b
    .AddConsoleExporter()
    .AddOtlpExporter(o =>
    {
        o.Protocol = OtlpExportProtocol.HttpProtobuf;
        var base_endpoint = Environment.GetEnvironmentVariable("DT_API_BASE_ENDPOINT");
        var full_endpoint = base_endpoint + "/v2/otlp/v1/traces";

        o.Endpoint = new Uri(full_endpoint); 
        o.HttpClientFactory = () =>
        {
            HttpClient client = new HttpClient();
            var authorization = "Api-Token " + Environment.GetEnvironmentVariable("DT_TOKEN");
            client.DefaultRequestHeaders.Add("Authorization", authorization);
            return client;
        };
    })
    /*.AddJaegerExporter(o =>
    {
        o.Protocol = JaegerExportProtocol.HttpBinaryThrift;
	    o.Endpoint = Environment.GetEnvironmentVariable("OTEL_ENDPOINT_URL");
        o.HttpClientFactory = () =>
        {
            HttpClient client = new HttpClient();
            return client;
        };
    })*/
    .AddSource(serviceName)
    .SetResourceBuilder(
        ResourceBuilder.CreateDefault()
            .AddService(serviceName: serviceName, serviceVersion: serviceVersion))
    .AddHttpClientInstrumentation()
    .AddAspNetCoreInstrumentation();
});

var app = builder.Build();

var MyActivitySource = new ActivitySource(serviceName);

var port = Environment.GetEnvironmentVariable("PORT") ?? "8080";
var url = $"http://0.0.0.0:{port}";
var target = Environment.GetEnvironmentVariable("TARGET") ?? "World";

HttpClient client = new HttpClient();

app.MapGet("/", () => $"Hello {target}!");
app.MapGet("/outraUrl", async () =>  {
    /*client.DefaultRequestHeaders.Accept.Clear();
    client.DefaultRequestHeaders.Accept.Add(
        new MediaTypeWithQualityHeaderValue("application/vnd.github.v3+json"));
    client.DefaultRequestHeaders.Add("User-Agent", ".NET Foundation Repository Reporter");    
    var responseTask = client.GetAsync("www.uol.com.br");
    var response = await responseTask;
    Console.WriteLine(response.Content);*/
    //$"Hello outraUrl!"
    var repositories = "";
    using var activity = MyActivitySource.StartActivity("SayHello");
    activity?.SetTag("foo", 1);
    activity?.SetTag("bar", "Hello, World!");
    activity?.SetTag("baz", new int[] { 1, 2, 3 });
    /*string [] fileEntries = Directory.GetFiles("/opt/dynatrace/oneagent/log");
    var repositories = "";
    foreach(string fileName in fileEntries){
        Console.WriteLine(fileName);
        string[] lines = System.IO.File.ReadAllLines(fileName);
        foreach (string line in lines)
        {
            // Use a tab to indent each line of the file.
            repositories += line;
            Console.WriteLine(line);
        }
    }*/
    
    client.DefaultRequestHeaders.Accept.Clear();
    client.DefaultRequestHeaders.Accept.Add(
        new MediaTypeWithQualityHeaderValue("application/vnd.github.v3+json"));
    client.DefaultRequestHeaders.Add("User-Agent", ".NET Foundation Repository Reporter");

    var streamTask = client.GetStreamAsync("https://api.github.com/orgs/dotnet/repos");
    var repo_list = await JsonSerializer.DeserializeAsync<List<WebAPIClient.Repository>>(await streamTask);
    foreach(WebAPIClient.Repository entry in repo_list){
        Console.WriteLine("Entry: "+ entry);
        repositories += entry.Name+", ";
    }
    char[] charToTrim = {',',' '};
    return repositories.Trim(charToTrim);
});

app.Run(url);

