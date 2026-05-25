from google.cloud import vision

def extract_text_with_layout(image_content: bytes):
    client = vision.ImageAnnotatorClient()
    image = vision.Image(content=image_content)
    response = client.text_detection(image=image)
    texts = response.text_annotations
    
    if not texts:
        return ""

    # Group tokens by line using y-coordinate and height
    tokens = texts[1:]
    if not tokens:
        return texts[0].description

    # Sort tokens by Y top, then X left
    sorted_tokens = sorted(tokens, key=lambda t: (t.bounding_poly.vertices[0].y, t.bounding_poly.vertices[0].x))

    lines = []
    current_line = []
    if sorted_tokens:
        last_y_top = sorted_tokens[0].bounding_poly.vertices[0].y
        last_y_bottom = sorted_tokens[0].bounding_poly.vertices[2].y
        
        for token in sorted_tokens:
            v = token.bounding_poly.vertices
            y_top = v[0].y
            y_bottom = v[2].y
            
            # Simple overlap check: if token's top is above current line's bottom
            if y_top < last_y_bottom - (last_y_bottom - last_y_top) / 2:
                current_line.append(token)
                last_y_top = min(last_y_top, y_top)
                last_y_bottom = max(last_y_bottom, y_bottom)
            else:
                lines.append(sorted(current_line, key=lambda t: t.bounding_poly.vertices[0].x))
                current_line = [token]
                last_y_top = y_top
                last_y_bottom = y_bottom
        
        if current_line:
            lines.append(sorted(current_line, key=lambda t: t.bounding_poly.vertices[0].x))

    reconstructed_text = ""
    for line in lines:
        line_str = " ".join([t.description for t in line])
        reconstructed_text += line_str + "\n"
        
    return reconstructed_text
