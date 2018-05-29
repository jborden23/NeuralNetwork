Class {
	#name : #SigmoidAF,
	#superclass : #ActivationFunction,
	#type : #variable,
	#category : #NeuralNetwork
}

{ #category : #actions }
SigmoidAF >> derivative: output [
	^ output * (1 - output)
]

{ #category : #actions }
SigmoidAF >> eval: z [
	^ 1 / (1 + z negated exp)
]
