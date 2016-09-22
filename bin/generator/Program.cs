using System;
using System.IO;
using System.Linq;
using System.Reflection;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Repometric.Dockers.Generator
{
    public class Program
    {
        public static void Main(string[] args)
        {
            const string configFile = @"docs/linters.json";
            const string defaultTemplate = @"default";
            var linters = JObject.Parse(File.ReadAllText(configFile));

            if (args[0] == "reformat") 
            {
                var reformat = new {
                    linters = linters["linters"].OrderBy(x => x["name"]),
                    platforms = linters["platforms"],
                    dockers = linters["dockers"],
                    licenses = linters["licenses"]
                };

                var content = JsonConvert.SerializeObject(reformat, Formatting.Indented);
                File.WriteAllText(configFile, content);
                return;
            }

            var image = args[0];

            var query = 
                from linter in linters["linters"]
                let name = (string)linter["name"]
                let platform = (string)linter["platform"]
                let docker = linters["dockers"][image][platform]
                let commands = linters["platforms"][platform]
                let path = @"dockers/" + image + "/" + name + "/"
                let config = linter["config"]
                let templateFile = "templates/" + ReadValue(config, "template", defaultTemplate)
                let template = File.ReadAllText(templateFile)
                let package = ReadValue(config, "package", name)
                let version = linter["version"]
                let cmd = ReadValue(commands, "latest", "")
                let run = Format(cmd, new { package })
                let model = new { docker, name, cmd, run, path }
                let content = platform == "TODO" ? "" : Format(template, model)
                select new { name, path, content };

            var list = query.ToList();
            foreach (var item in list)
            {
                if (string.IsNullOrEmpty(item.content))
                {
                    Console.WriteLine("TODO: " + item.name);
                    continue;
                }

                Directory.CreateDirectory(item.path);
                File.WriteAllText(item.path + "Dockerfile", item.content);
                Console.WriteLine("Generate: " + item.name);
            }

            Console.WriteLine("Total: " + list.Count);
        }

        static string ReadValue(JToken config, string name, string defaultValue)
        {
            return (string)(config != null && config[name] != null ? config[name] : defaultValue);
        }

        static string Format(string input, object p)
        {
            foreach (var prop in p.GetType().GetProperties())
            {
                input = input.Replace("{" + prop.Name + "}", (prop.GetValue(p) ?? "(null)").ToString());
            }
            return input;
        }
    }
}
