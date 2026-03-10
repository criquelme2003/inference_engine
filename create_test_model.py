import tensorflow as tf
import tf2onnx
import onnx

model = tf.keras.Sequential([
    tf.keras.Input(shape=(3,)),
    tf.keras.layers.Dense(4, activation="relu"),
    tf.keras.layers.Dense(2),
    tf.keras.layers.Softmax()
])

@tf.function
def forward(x):
    return model(x)

input_signature = [tf.TensorSpec([None, 3], tf.float32)]

onnx_model, _ = tf2onnx.convert.from_function(
    forward,
    input_signature=input_signature,
    opset=13
)

onnx.save(onnx_model, "/workspace/models/model.onnx")