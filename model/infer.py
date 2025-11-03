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
import cv2
from ultralytics import YOLO
from flask import send_file

app = Flask(__name__)

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


coco_labels = [
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

labels = [
    "door",
    "stairs",
    "chair/stool/sofa",
    "table/dining table/center table",
    "person",
    "trash bin",
    "bag/school bag/ backpack",
    "cabinet/drawer",
    "stand fan/electric fan/floor fan"
]

def normalize_label(raw_label: str):
    if not raw_label:
        return None
    r = raw_label.lower()
    if "door" in r:
        return "door"
    if "stair" in r or "steps" in r:
        return "stairs"
    if any(k in r for k in ("chair", "stool", "sofa", "couch", "bench")):
        return "chair/stool/sofa"
    if any(k in r for k in ("dining table", "center table", "coffee table")) or "table" in r:
        return "table/dining table/center table"
    if "person" in r or r == "people":
        return "person"
    if any(k in r for k in ("trash", "bin", "garbage", "waste")):
        return "trash bin"
    if any(k in r for k in ("backpack", "bag", "handbag", "school bag", "rucksack")):
        return "bag/school bag/ backpack"
    if any(k in r for k in ("cabinet", "drawer", "dresser", "filing")):
        return "cabinet/drawer"
    if "fan" in r:
        return "stand fan/electric fan/floor fan"
    return None
# ...existing code...
yolo_model = YOLO("./weights/best.pt")
 

@app.route("/detect", methods=["POST"])
def detect():
    try:
        image = None
        is_file_upload = False  # ✅ Track if request was multipart

        # ✅ Case 1: multipart form-data (file upload)
        if "file" in request.files:
            is_file_upload = True
            file = request.files["file"]
            if file.filename == "":
                return jsonify({"error": "No file selected"}), 400
            file_bytes = file.read()
            np_arr = np.frombuffer(file_bytes, np.uint8)
            image = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
            image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

        # ✅ Case 2: JSON with base64
        elif request.is_json:
            data = request.get_json()
            if "image" not in data:
                return jsonify({"error": "Missing 'image' field"}), 400
            image = load_base64_image(data["image"])

        else:
            return jsonify({"error": "No valid image provided"}), 400

        image_np = np.array(image)

        # 🔹 Near detection mode
        if request.form.get("neardetection") == "true" or (
            request.is_json and (data.get("neardetection") is True)
        ):

            frcnn_model = hub.load(
                "https://tfhub.dev/tensorflow/faster_rcnn/inception_resnet_v2_1024x1024/1"
            )
            input_tensor = tf.convert_to_tensor([image_np], dtype=tf.uint8)
            detector_output = frcnn_model(input_tensor)

            boxes = detector_output["detection_boxes"].numpy()[0]
            scores = detector_output["detection_scores"].numpy()[0]
            classes = detector_output["detection_classes"].numpy()[0].astype(int)

            results = []
            for i in range(len(scores)):
                if scores[i] < 0.5:
                    continue
                # Map COCO class index -> raw label -> normalized client label; skip if not in client set
                raw_label = coco_labels[classes[i] - 1] if (classes[i] - 1) < len(coco_labels) else str(classes[i])
                norm = normalize_label(raw_label)
                if norm is None:
                    continue
                results.append({
                    "class": norm,
                    "score": float(scores[i]),
                    "bbox": boxes[i].tolist()
                })

            # ✅ If file upload → return image with bbox
            if is_file_upload and results:
                annotated = draw_bboxes(image_np.copy(), results)
                _, buffer = cv2.imencode(".jpg", cv2.cvtColor(annotated, cv2.COLOR_RGB2BGR))
                return send_file(
                    io.BytesIO(buffer.tobytes()),
                    mimetype="image/jpeg",
                    as_attachment=False,
                    download_name="detection.jpg"
                )

            return jsonify({"detections": results})

        # 🔹 YOLO + fallback detection
        image_cv = cv2.cvtColor(image_np, cv2.COLOR_RGB2BGR)
        img_resized = cv2.resize(image_cv, (224, 224))

        yolo_results = yolo_model.predict(img_resized, verbose=False)
        yolo_result = yolo_results[0]

        top_class_idx = yolo_result.probs.top1
        top_class_conf = yolo_result.probs.top1conf
        class_name = yolo_result.names[top_class_idx]

        # Normalize YOLO class and only keep if it maps to a client label
        norm_yolo = normalize_label(class_name)
        if norm_yolo:
            result = [{
                "class": norm_yolo,
                "score": float(top_class_conf),
                "bbox": None
            }]
        else:
            result = []
 
        if result and is_file_upload:
            annotated = draw_bboxes(image_np.copy(), result)
            _, buffer = cv2.imencode(".jpg", cv2.cvtColor(annotated, cv2.COLOR_RGB2BGR))
            return send_file(io.BytesIO(buffer.tobytes()), mimetype="image/jpeg")
        if result:
            return jsonify({"detections": result})

        input_tensor = tf.convert_to_tensor([image_np], dtype=tf.uint8)
        detector_output = model(input_tensor)

        boxes = detector_output["detection_boxes"].numpy()[0]
        scores = detector_output["detection_scores"].numpy()[0]
        classes = detector_output["detection_classes"].numpy()[0].astype(int)

        results = []
        for i in range(len(scores)):
            if scores[i] < 0.5:
                continue
            raw_label = coco_labels[classes[i] - 1] if (classes[i] - 1) < len(coco_labels) else str(classes[i])
            if raw_label == "horse":
                raw_label = "dog"
            norm = normalize_label(raw_label)
            if norm is None:
                continue
            results.append({
                "class": norm,
                "score": float(scores[i]),
                "bbox": boxes[i].tolist()
            })

        # ✅ Return image if file upload, JSON otherwise
        if is_file_upload and results:
            annotated = draw_bboxes(image_np.copy(), results)
            _, buffer = cv2.imencode(".jpg", cv2.cvtColor(annotated, cv2.COLOR_RGB2BGR))
            return send_file(io.BytesIO(buffer.tobytes()), mimetype="image/jpeg")

        return jsonify({"detections": results})

    except Exception as e:
        return jsonify({"error": str(e)}), 500


def draw_bboxes(image, results):
    """Draw bounding boxes on the image based on results."""
    h, w, _ = image.shape
    for det in results:
        if det["bbox"]:
            y1, x1, y2, x2 = det["bbox"]
            pt1 = (int(x1 * w), int(y1 * h))
            pt2 = (int(x2 * w), int(y2 * h))
            cv2.rectangle(image, pt1, pt2, (0, 255, 0), 2)
            cv2.putText(
                image,
                f"{det['class']} {det['score']:.2f}",
                (pt1[0], pt1[1] - 10),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.5,
                (0, 255, 0),
                2
            )
    return image

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")


# ngrok config add-authtoken 2m5jqEu9zvNYOb79eZxlWZuAJY0_2pwdj8nUB4nWYbeR55XUo
# ngrok http 192.168.100.12:5000