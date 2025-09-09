import cv2
from ultralytics import YOLO

model = YOLO("./weights/best.pt")


# Open webcam
cap = cv2.VideoCapture(0)
if not cap.isOpened():
    raise RuntimeError("Cannot open webcam")

while True:
    ret, frame = cap.read()
    if not ret:
        print("Failed to grab frame")
        break

    # Resize for model input (optional, YOLO can handle dynamic size)
    img = cv2.resize(frame, (224, 224))

    # Predict
    results = model.predict(img, verbose=False)
    result = results[0]

    # Get Top-1 class and confidence
    top_class_idx = result.probs.top1
    top_class_conf = result.probs.top1conf
    class_name = result.names[top_class_idx]

    # Overlay prediction on frame
    cv2.putText(frame, f"{class_name} ({top_class_conf:.2f})", (10, 40),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    # Show frame
    cv2.imshow("YOLOv11 Real-Time Classifier", frame)

    # Press 'q' to quit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
