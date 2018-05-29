"
I am taken from https://agileartificialintelligence.github.io/book/build/02-Perceptron.html
 
Internal Representation and Key Implementation Points.

    Instance Variables
	bias:		<aNumber>
	weights:		<ArrayofNumbers>


    Implementation Points
"
Class {
	#name : #Neuron,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'weights',
		'bias',
		'delta',
		'output',
		'activationFunction'
	],
	#category : #NeuralNetwork
}

{ #category : #actions }
Neuron >> adjustBiasUsingLearningRate: learningRate [
	bias := bias + (learningRate * delta)
]

{ #category : #actions }
Neuron >> adjustDeltaWith: anError [
	delta := anError * (activationFunction derivative: output)
]

{ #category : #actions }
Neuron >> adjustWeightWithInput: inputs learningRate: learningRate [
	inputs
		withIndexDo:
			[ :anInput :index | weights at: index put: (weights at: index) + (learningRate * delta * anInput) ]
]

{ #category : #accessing }
Neuron >> bias [
	^ bias
]

{ #category : #accessing }
Neuron >> bias: aNumber [
	bias := aNumber
]

{ #category : #accessing }
Neuron >> delta [
	^ delta
]

{ #category : #actions }
Neuron >> feed: inputs [
	| z |
	z := (inputs with: weights collect: [ :x :w | x * w ]) sum + bias.
	output := activationFunction eval: z.
	^ output
]

{ #category : #initialization }
Neuron >> initialize [
	super initialize.
	self sigmoid
]

{ #category : #accessing }
Neuron >> output [
	"Return the output value, previous computed when doing a feed:"

	^ output
]

{ #category : #initialization }
Neuron >> sigmoid [
	activationFunction := SigmoidAF new
]

{ #category : #initialization }
Neuron >> step [
	activationFunction := StepAF new
]

{ #category : #actions }
Neuron >> train: inputs desiredOutput: desiredOutput [
	| learningRate theError output delta |
	output := self feed: inputs.
	learningRate := 0.1.
	theError := desiredOutput - output.
	delta := theError * (activationFunction derivative: output).
	inputs
		withIndexDo:
			[ :anInput :index | weights at: index put: (weights at: index) + (learningRate * delta * anInput) ].
	bias := bias + (learningRate * delta)
]

{ #category : #accessing }
Neuron >> weights [
	^weights
]

{ #category : #accessing }
Neuron >> weights: someWeightsAsNumbers [
	weights := someWeightsAsNumbers
]
