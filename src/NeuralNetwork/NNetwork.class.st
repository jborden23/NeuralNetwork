Class {
	#name : #NNetwork,
	#superclass : #Object,
	#instVars : [
		'layers',
		'errors'
	],
	#category : #NeuralNetwork
}

{ #category : #adding }
NNetwork >> addLayer: aNeuronLayer [
	"Add a neural layer. The added layer is linked to the already added layers."

	layers
		ifNotEmpty: [ aNeuronLayer previousLayer: layers last.
			layers last nextLayer: aNeuronLayer ].
	layers add: aNeuronLayer
]

{ #category : #actions }
NNetwork >> backwardPropagateError: expected [
	self outputLayer backwardPropagateError: expected
]

{ #category : #initialization }
NNetwork >> configure: nbOfInputs hidden: nbOfNeurons1 hidden: nbOfNeurons2 nbOfOutputs: nbOfOutput [
	"Configure the network with the given parameters
    The network has only one hidden layer"

	| random |
	random := Random seed: 42.
	self
		addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons1 nbOfWeights: nbOfInputs using: random).
	self
		addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons2 nbOfWeights: nbOfNeurons1 using: random).
	self
		addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfOutput nbOfWeights: nbOfNeurons2 using: random)
]

{ #category : #initialization }
NNetwork >> configure: nbOfInputs hidden: nbOfNeurons nbOfOutputs: nbOfOutput [
	"Configure the network with the given parameters
    The network has only one hidden layer"

	| random |
	random := Random seed: 42.
	self
		addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons nbOfWeights: nbOfInputs using: random).
	self
		addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfOutput nbOfWeights: nbOfNeurons using: random)
]

{ #category : #actions }
NNetwork >> feed: someInputValues [
	"Feed the first layer with the provided inputs"

	^ layers first feed: someInputValues
]

{ #category : #initialization }
NNetwork >> initialize [
	super initialize.
	layers := OrderedCollection new.
	errors := OrderedCollection new
]

{ #category : #accessing }
NNetwork >> numberOfOutputs [
	^ self outputLayer neurons size
]

{ #category : #accessing }
NNetwork >> outputLayer [
	"Return the output layer, which is also the last layer"

	^ layers last
]

{ #category : #actions }
NNetwork >> predict: inputs [
	"Make a prediction. This method assume that the number of outputs is the same than the number of different values the network can output"

	| outputs |
	outputs := self feed: inputs.
	^ (outputs indexOf: outputs max) - 1
]

{ #category : #actions }
NNetwork >> train: someInputs desiredOutputs: desiredOutputs [
	"Train the neural network with a set of inputs and some expected output"

	| realOutputs t |
	realOutputs := self feed: someInputs.
	t := (1 to: desiredOutputs size)
		collect: [ :i | (desiredOutputs at: i) - (realOutputs at: i) raisedTo: 2 ].
	self backwardPropagateError: desiredOutputs.
	self updateWeight: someInputs
]

{ #category : #actions }
NNetwork >> train: train nbEpoch: nbEpoch [
	"Train the network using the train data set."

	| sumError outputs expectedOutput t |
	1 to: nbEpoch do: [ :epoch | 
		sumError := 0.
		train
			do: [ :row | 
				outputs := self feed: row allButLast.
				expectedOutput := (1 to: self numberOfOutputs) collect: [ :notUsed | 0 ].
				expectedOutput at: row last + 1 put: 1.
				t := (1 to: expectedOutput size)
					collect: [ :i | (expectedOutput at: i) - (outputs at: i) raisedTo: 2 ].
				sumError := sumError + t sum.
				self backwardPropagateError: expectedOutput.
				self updateWeight: row allButLast ].
		errors add: sumError ]
]

{ #category : #accessing }
NNetwork >> updateWeight: initialInputs [
	"Update the weights of the neurons using the initial inputs"

	layers first updateWeight: initialInputs
]

{ #category : #'as yet unclassified' }
NNetwork >> viewErrorCurve [
	| b ds |
	errors
		ifEmpty: [ ^ RTView new
				add: (RTLabel elementOn: 'Should first run the network');
				yourself ].
	b := RTGrapher new.

	"We define the size of the charting area"
	b extent: 500 @ 300.
	ds := RTData new.
	ds noDot.
	ds connectColor: Color blue.
	ds points: errors.
	ds dotShape rectangle color: Color blue.
	b add: ds.
	b axisX
		noDecimal;
		title: 'Epoch'.
	b axisY title: 'Error'.
	^ b
]

{ #category : #'as yet unclassified' }
NNetwork >> viewErrorCurveIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'Error';
		initializeView: [ self viewErrorCurve ]
]

{ #category : #'as yet unclassified' }
NNetwork >> viewNetwork [
	| b lb |
	b := RTMondrian new.
	b
		nodes: layers
		forEach: [ :aLayer | 
			b shape circle size: 20.
			b nodes: aLayer neurons.
			b layout verticalLine ].
	b shape
		arrowedLine;
		withShorterDistanceAttachPoint.
	b edges connectTo: #nextLayer.
	b layout horizontalLine
		gapSize: 30;
		center.
	b build.
	lb := RTLegendBuilder new.
	lb view: b view.
	lb addText: self numberOfNeurons asString , ' neurons'.
	lb addText: self numberOfInputs asString , ' inputs'.
	lb build.
	^ b view
]

{ #category : #'as yet unclassified' }
NNetwork >> viewNetworkIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'network';
		initializeView: [ self viewNetwork ]
]
