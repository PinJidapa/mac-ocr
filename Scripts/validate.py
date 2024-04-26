import json
import jsonschema

def validate_json_schema(input_json, reference_schema_path):
    reference_schema = None
    with open(reference_schema_path, 'r') as f:
        reference_schema = json.load(f)
    return jsonschema.validate(input_json, reference_schema)