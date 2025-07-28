from flask import Flask, request, jsonify
from PIL import Image
import io
import base64
import numpy as np
import tensorflow as tf
import tensorflow_hub as hub

app = Flask(__name__)

model = hub.load("https://tfhub.dev/tensorflow/ssd_mobilenet_v2/2")

labels = [
    "person", "bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck",
    "boat", "traffic light", "fire hydrant", "stop sign", "parking meter", "bench",
    "bird", "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra",
    "giraffe", "backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee",
    "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball glove",
    "skateboard", "surfboard", "tennis racket", "bottle", "wine glass", "cup",
    "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange",
    "broccoli", "carrot", "hot dog", "pizza", "donut", "cake", "chair", "couch",
    "potted plant", "bed", "dining table", "toilet", "tv", "laptop", "mouse",
    "remote", "keyboard", "cell phone", "microwave", "oven", "toaster", "sink",
    "refrigerator", "book", "clock", "vase", "scissors", "teddy bear", "hair drier",
    "toothbrush"
]

def load_base64_image(base64_str):
    header, encoded = base64_str.split(",", 1) if "," in base64_str else ("", base64_str)
    image_data = base64.b64decode(encoded)
    image = Image.open(io.BytesIO(image_data)).convert("RGB")
    return image

@app.route("/detect", methods=["POST"])
def detect():
    data = request.get_json()
    if "image" not in data:
        return jsonify({"error": "Missing 'image' field"}), 400

    try:
        image = load_base64_image(data["image"])
        image_np = np.array(image)
        input_tensor = tf.convert_to_tensor([image_np], dtype=tf.uint8)

        detector_output = model(input_tensor)

        boxes = detector_output["detection_boxes"].numpy()[0]
        scores = detector_output["detection_scores"].numpy()[0]
        classes = detector_output["detection_classes"].numpy()[0].astype(int)

        results = []
        for i in range(len(scores)):
            if scores[i] < 0.5:
                continue
            label = labels[classes[i] - 1]
            if label == "horse":
                label = "dog"
            results.append({
                "class": label,
                "score": float(scores[i]),
                "bbox": boxes[i].tolist()
            })
        print(results)
        return jsonify({"detections": results})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
