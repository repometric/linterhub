dockers:
	dotnet run -p bin/generator reformat
	dotnet run -p bin/generator alpine

tests:
	sh bin/test.sh alpine
