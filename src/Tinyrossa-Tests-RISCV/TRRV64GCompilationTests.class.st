Class {
	#name : #TRRV64GCompilationTests,
	#superclass : #TRCompilationTestCase,
	#category : #'Tinyrossa-Tests-RISCV'
}

{ #category : #running }
TRRV64GCompilationTests >> setUp [
	self setUpForTarget: TRRV64GLinux default
]

{ #category : #'tests - examples' }
TRRV64GCompilationTests >> test_example01_meaningOfLife [
	| debugger status |

	TRCompilationExamples new
		compilation: compilation;
		example01_meaningOfLife.

	debugger := shell debugger.
	debugger memoryAt: shell nzone put: compilation codeBuffer bytes.
	status := debugger c.
	self assert: (status isKindOf: DebugStopped).
	self assert: (debugger getRegister: 'a0') equals: 42.
	self assert: (debugger pc) equals: 0.
]

{ #category : #'tests - examples' }
TRRV64GCompilationTests >> test_example04_factorial_i [
	| debugger |

	TRCompilationExamples new
		compilation: compilation;
		example04_factorial_i.

	debugger := shell debugger.
	debugger memoryAt: shell nzone put: compilation codeBuffer bytes.
	debugger setRegister: 'a0' to: 5.
	debugger c.
	self assert: (debugger getRegister: 'a0') equals: 5 factorial.
]

{ #category : #'tests - examples' }
TRRV64GCompilationTests >> test_example05_factorial_r [
	| debugger |

	TRCompilationExamples new
		compilation: compilation;
		example05_factorial_r.

	debugger := shell debugger.
	debugger memoryAt: shell nzone put: compilation codeBuffer bytes.
	debugger setRegister: 'a0' to: 5.
	debugger c.
	self assert: (debugger getRegister: 'a0') equals: 5 factorial.
]
