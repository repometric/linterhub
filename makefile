dockers:
	dotnet run -p bin/generator reformat
	dotnet run -p bin/generator alpine

tests:
	sh bin/lh_test.sh alpine
