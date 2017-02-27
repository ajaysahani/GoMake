#define all constant and variables
TargetName 	:= jas
BaseFolder	:=	build
TargetZip	:=	.zip
LinterFile	:=	static-analysis.xml
CoverAll := cover-all
CoverageFile	:=	cover-cobertura
sources	:=	$(wildcard *.go)

Version=1.0.0
Build=`git rev-parse HEAD`

build		=	go build ${LDFLAGS} -o $(BaseFolder)/$(TargetName) *.go
zip		=	cd $(BaseFolder) && zip -r $(TargetName)$(TargetZip) *


.PHONY:	all	clean

#Setup the -ldflag option for go build here, interpolate the variable values
LDFLAGS=-ldflags "-X main.Version=${Version} -X main.Build=${Build}"

#build binary
BuildCommand:	$(sources)
	$(call build)
	$(call zip)

#install binary
install:
	go install ${LDFLAGS}

#peroform all action in single step
all:	clean	BuildCommand	test	cover	code-quality	output-formatted

#clean output
clean:
	rm -rf $(BaseFolder)/$(CoverAll).out
	rm -rf $(BaseFolder)/$(CoverAll).html
	rm -rf $(BaseFolder)/$(CoverageFile).xml
	rm -rf $(BaseFolder)/$(LinterFile)
	rm -rf $(BaseFolder)/$(TargetName)$(TargetZip)
	rm -rf $(BaseFolder)/$(TargetName)
	rm -rf ./util/cover.out

#suit for all test cases
test:
	go test -coverprofile ./util/cover.out -covermode=count ./util   

#coverage for all package test cases
cover:
	echo "mode: count" >  $(BaseFolder)/$(CoverAll).out
	tail -n +2 ./util/cover.out >> $(BaseFolder)/$(CoverAll).out
	gocover-cobertura <  $(BaseFolder)/$(CoverAll).out > $(BaseFolder)/$(CoverageFile).xml

#consolidate code quality check
code-quality:
	- gometalinter --vendor --tests --skip=mock --disable=dupl --disable=gotype --disable=errcheck --disable=gas --deadline=5000s --checkstyle --sort=linter ./... > $(BaseFolder)/$(LinterFile) 

#better reprsentation for output	
output-formatted:
	go tool cover -html=./$(BaseFolder)/$(CoverAll).out -o ./$(BaseFolder)/$(CoverAll).html
	go tool cover -func=./$(BaseFolder)/$(CoverAll).out
