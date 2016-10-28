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
            var versionType = "latest";
            var lintersFile = File.ReadAllText(configFile);

            if (args[0] == "reformat") 
            {
                var lintersJson = JObject.Parse(lintersFile);
                var reformat = new {
                    linters = lintersJson["linters"].OrderBy(x => x["name"]),
                    platforms = lintersJson["platforms"],
                    dockers = lintersJson["dockers"],
                    licenses = lintersJson["licenses"]
                };

                var content = JsonConvert.SerializeObject(reformat, Formatting.Indented);
                File.WriteAllText(configFile, content);
                return;
            }

            var image = args[0];

            var linters = JsonConvert.DeserializeObject<Linters>(lintersFile);
            var query = 
                from linter in linters.linters
                let docker = linters.dockers[image][linter.platform]
                let commands = linters.platforms[linter.platform]
                let path = @"dockers/" + image + "/" + linter.name + "/"
                let templateFile = "templates/" + ReadValue(linter.config, "template", defaultTemplate)
                let template = File.ReadAllText(templateFile)
                let package = ReadValue(linter.config, "package", linter.name)
                let cmd = ReadValue(commands, versionType, "")
                let run = Format(cmd, new { package })
                let model = new { docker, linter.name, cmd, run, path }
                let content = linter.platform == "TODO" ? "" : Format(template, model)
                select new { linter.name, path, content };

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

        public class Linters
        {
            public Linter[] linters;
            public JObject platforms;
            public JObject licenses;
            public JObject dockers;
            public class Linter
            {
                public string name;
                public string version;
                public string description;
                public string url;
                public string languages;
                public string license;
                public string platform;
                public JObject config;
            }
        }
    }
}
