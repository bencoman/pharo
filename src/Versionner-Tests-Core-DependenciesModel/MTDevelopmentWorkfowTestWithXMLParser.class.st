Class {
	#name : #MTDevelopmentWorkfowTestWithXMLParser,
	#superclass : #MTDevelopmentWorkfowTest,
	#category : #'Versionner-Tests-Core-DependenciesModel'
}

{ #category : #utility }
MTDevelopmentWorkfowTestWithXMLParser >> setDevelopment: aVersionString [
	project configurationClass compile: 'development: spec
	<symbolicVersion: #''development''>

	spec for: #''common'' version: ''' , aVersionString , '''.'
]

{ #category : #running }
MTDevelopmentWorkfowTestWithXMLParser >> setUp [
	"Create a model of the project version we want to work on."
	| version |
	super setUp.
	"create a copy of the class to don't pollute the configuration with code generated for tests purposes"
	classFactory := ClassFactoryForTestCase new.
	class := classFactory duplicateClass: ConfigurationOfVersionnerTestXMLParserTemplate withNewName: #ConfigurationOfVersionnerTestXMLParser.
	
	visitor := MCModel2MTModelVisitor new.
	version := class project version: '1.1'.
	project := visitor visitConfiguration: class withVersion: version.
		
]

{ #category : #running }
MTDevelopmentWorkfowTestWithXMLParser >> tearDown [ 
	classFactory cleanUp.
]

{ #category : #tests }
MTDevelopmentWorkfowTestWithXMLParser >> testCreateBaseline [
	| baselineName baseline |
	
	baselineName := '84.1'.
	project devWorkflow createBaseline: baselineName. 
	
	"Visit the created baseline"
	baseline := project configurationClass project version: baselineName.
	project := visitor visitConfiguration: project configurationClass withVersion: baseline.
	self assert: project notNil.
	self assert: project name equals: 'VersionnerTestXMLParser'.
	self assert: project version name equals: baselineName.

]

{ #category : #tests }
MTDevelopmentWorkfowTestWithXMLParser >> testCreateNextDevelopment [
	project devWorkflow createNextDevelopment: '999'.
	self assert: (project configurationClass selectors includes: #'baseline999:').
]

{ #category : #tests }
MTDevelopmentWorkfowTestWithXMLParser >> testIsDevelopmentUsedInRelease [
	| workflow |
	workflow := project devWorkflow.
	self assert: workflow isDevelopmentUsedInRelease equals: false.
	
	self setDevelopment: '1.0-baseline'.
	self assert: workflow isDevelopmentUsedInRelease equals: true.
	
	self setDevelopment: '2.0-baseline'.
	self assert: workflow isDevelopmentUsedInRelease equals: false.
	
	self setDevelopment: '1.1'.
	self assert: workflow isDevelopmentUsedInRelease equals: false.

]
