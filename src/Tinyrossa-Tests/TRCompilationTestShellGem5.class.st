Class {
	#name : #TRCompilationTestShellGem5,
	#superclass : #TRCompilationTestShell,
	#instVars : [
		'gem5'
	],
	#classVars : [
		'Host'
	],
	#category : #'Tinyrossa-Tests-Shells-SmalltalkX'
}

{ #category : #accessing }
TRCompilationTestShellGem5 class >> host [
	^ Host isNil ifTrue: [ 'unleashed' ] ifFalse: [ Host ]
]

{ #category : #accessing }
TRCompilationTestShellGem5 class >> host: aString [
	Host := aString
]

{ #category : #running }
TRCompilationTestShellGem5 >> setUp [

	super setUp.
	debugger := RemoteGDB host: 'localhost' port: 7000.
	
]

{ #category : #running }
TRCompilationTestShellGem5 >> tearDown [
	super tearDown.
	gem5 notNil ifTrue: [ 
		gem5 waitUntilFinishedWithTimeout: 1
	].
]
