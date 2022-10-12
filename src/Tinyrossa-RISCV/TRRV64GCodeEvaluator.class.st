Class {
	#name : #TRRV64GCodeEvaluator,
	#superclass : #TRCodeEvaluator,
	#instVars : [
		'generate'
	],
	#pools : [
		'TRRV64GRegisters'
	],
	#category : #'Tinyrossa-RISCV-Codegen'
}

{ #category : #accessing }
TRRV64GCodeEvaluator >> codegen [
	^ codegen
]

{ #category : #accessing }
TRRV64GCodeEvaluator >> compilation [
	^ self codegen compilation
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_bbstart: node [
	| label |

	label := self compilation symbolManager lookupLabelByBlock: node block.
	label notNil ifTrue: [ 
		generate label: label name.
	].
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_goto: node [
	generate
		jal: zero, node symbol
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_iadd: node [
	| src1Reg src2Reg dstReg |

	"FIXME: if second operand is iconst,
	 use addi"
	src1Reg := self evaluate: node child1.
	src2Reg := self evaluate: node child2.
	dstReg := self codegen allocateRegister.
	generate
		addw: dstReg, src1Reg, src2Reg.

	^ dstReg
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_iconst: node [
	| dstReg |

	node constant == 0 ifTrue: [ ^ zero ].

	dstReg := self codegen allocateRegister.

	generate 
		addi: dstReg, zero, node constant.

	^ dstReg
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_ificmpge: node [
	| src1Reg src2Reg |

	src1Reg := self evaluate: node child1.
	src2Reg := self evaluate: node child2.
	^ generate 
		bge: src1Reg, src2Reg, node symbol
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_ificmpgt: node [
	| src1Reg src2Reg |

	src1Reg := self evaluate: node child1.
	src2Reg := self evaluate: node child2.
	^ generate 
		blt: src2Reg, src1Reg, node symbol
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_ificmple: node [
	| src1Reg src2Reg |

	src1Reg := self evaluate: node child1.
	src2Reg := self evaluate: node child2.
	^ generate 
		bge: src2Reg, src1Reg, node symbol
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_iload: node [
	"superclass TRILEvaluator says that I am responsible to implement this method"

	| dstReg |

	dstReg := node symbol register.
	dstReg notNil ifTrue: [ 
		"Nothing"
	] ifFalse: [ 
		self notYetImplemented
	].

	^ dstReg
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_imul: node [
	| src1Reg src2Reg dstReg |

	src1Reg := self evaluate: node child1.
	src2Reg := self evaluate: node child2.
	dstReg := self codegen allocateRegister.
	generate
		mulw: dstReg, src1Reg, src2Reg.

	^ dstReg
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_istore: node [
	| srcReg dstReg |

	srcReg := self evaluate: node child1.
	dstReg := node symbol register.


	dstReg notNil ifTrue: [ 
		generate
			addi: dstReg, srcReg, 0
	] ifFalse: [ 
		self notYetImplemented
	].

	^ dstReg
]

{ #category : #evaluation }
TRRV64GCodeEvaluator >> evaluate_isub: node [
	| src1Reg src2Reg dstReg |

	"FIXME: if second operand is iconst,
	 use addi"
	src1Reg := self evaluate: node child1.
	src2Reg := self evaluate: node child2.
	dstReg := self codegen allocateRegister.
	generate
		subw: dstReg, src1Reg, src2Reg.

	^ dstReg
]

{ #category : #private }
TRRV64GCodeEvaluator >> ground: instruction using: encoding [ 
	| insn |

	insn := instruction as: codegen instructionClass.
	insn setBinaryEncoding: encoding.
	 "Set the TRIL node that caused this instruction to be generated - if not
	 already set (which happens when you ground a partially grounded
	 instruction).
	 It's bit tricky, but this is the API that ArchC provides at the moment.
	""Set the TRIL node that caused this instruction to be generated - if not
	 already set (which happens when you ground a partially grounded
	 instruction).
	 It's bit tricky, but this is the API that ArchC provides at the moment.
	"
	insn node isNil ifTrue: [
		insn node: currentNode.
	].
	^ insn
]

{ #category : #initialization }
TRRV64GCodeEvaluator >> initializeWithCodeGenerator: aTRCodeGenerator [ 
	super initializeWithCodeGenerator: aTRCodeGenerator.
	generate := codegen assembler.
	generate grounder: self.
]