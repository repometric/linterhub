dockers:
	dotnet run -p src/generator reformat
	dotnet run -p src/generator alpine

tests:
	sh bin/lh_test.sh alpine
