from flask import Flask, request, jsonify
from PIL import Image
import io
import base64
import numpy as np
import tensorflow as tf
import tensorflow_hub as hub
import random
import base64
import io
import json
import tempfile
import numpy as np
from flask import Flask, request, jsonify
from inference_sdk import InferenceHTTPClient
from PIL import Image, ImageDraw

app = Flask(__name__)

model = hub.load("https://tfhub.dev/tensorflow/ssd_mobilenet_v2/2")


def preprocess_image_for_model(image, target_size=(224, 224), normalize=True, to_array=True):
    if not isinstance(image, Image.Image):
        raise TypeError("Expected a PIL Image.")
    image = image.resize(target_size)
    image = image.convert("RGB")
    if to_array:
        image_array = np.array(image)
        if normalize:
            image_array = image_array.astype("float32") / 255.0
        image_array = np.expand_dims(image_array, axis=0)
        return image_array
    return image

def draw_bounding_boxes(image, predictions, label_key='class', box_key='bbox'):
    from PIL import ImageDraw, ImageFont
    draw = ImageDraw.Draw(image)
    try:
        font = ImageFont.truetype("arial.ttf", 16)
    except:
        font = ImageFont.load_default()
    for pred in predictions:
        bbox = pred.get(box_key)
        label = pred.get(label_key, "Object")
        if bbox:
            x1, y1, x2, y2 = map(int, bbox)
            draw.rectangle([x1, y1, x2, y2], outline="red", width=2)
            draw.text((x1, y1 - 10), label, fill="white", font=font)
    return image

def filter_predictions_by_confidence(predictions, threshold=0.2, conf_key='confidence'):
    if not isinstance(predictions, list):
        raise TypeError("Predictions must be a list of dictionaries.")
    filtered = []
    for pred in predictions:
        conf = pred.get(conf_key, 0)
        if conf >= threshold:
            filtered.append(pred)
    return filtered

def generate_prediction_report(predictions, image_name="image.jpg", save_path="report.json"):
    from datetime import datetime
    report = {
        "image": image_name,
        "timestamp": datetime.now().isoformat(),
        "num_predictions": len(predictions),
        "predictions": predictions
    }
    with open(save_path, 'w') as f:
        json.dump(report, f, indent=4)
    return save_path

def resize_image(image, size=(224, 224)):
    if not isinstance(image, Image.Image):
        raise TypeError("Input must be a PIL image.")
    return image.resize(size)

def is_valid_image_format(image_bytes):
    try:
        Image.open(io.BytesIO(image_bytes)).verify()
        return True
    except Exception:
        return False

def convert_to_grayscale(image):
    if not isinstance(image, Image.Image):
        raise TypeError("Expected a PIL Image.")
    return image.convert("L")

def normalize_pixels(image):
    if not isinstance(image, Image.Image):
        raise TypeError("Expected a PIL Image.")
    return np.array(image) / 255.0

def save_image_locally(image, filename="saved_image.jpg"):
    if not isinstance(image, Image.Image):
        raise TypeError("Expected a PIL Image.")
    image.save(filename)
    return filename

def encode_image_to_base64(image):
    buffered = io.BytesIO()
    image.save(buffered, format="JPEG")
    return base64.b64encode(buffered.getvalue()).decode()

def log_prediction_result(result, log_file='inference_log.txt'):
    with open(log_file, 'a') as f:
        f.write(json.dumps(result) + '\n')

def detect_blank_image(image):
    np_img = np.array(image)
    return (np_img > 240).mean() > 0.95

def get_image_dimensions(image):
    if not isinstance(image, Image.Image):
        raise TypeError("Expected a PIL Image.")
    return image.size

def decode_base64_image(base64_str):
    try:
        img_data = base64.b64decode(base64_str)
        return Image.open(io.BytesIO(img_data))
    except Exception as e:
        raise ValueError("Invalid base64 image") from e



def draw_boxes(image, predictions):
    draw = ImageDraw.Draw(image)
    for pred in predictions:
        x = pred['x']
        y = pred['y']
        w = pred['width']
        h = pred['height']
        label = pred.get('class', '')
        left = x - w / 2
        top = y - h / 2
        right = x + w / 2
        bottom = y + h / 2
        draw.rectangle([left, top, right, bottom], outline='red', width=3)
        text_position = (left, top - 15)
        draw.text(text_position, label, fill='red')
    return image


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
