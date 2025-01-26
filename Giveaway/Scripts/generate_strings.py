import json
import os
import sys

# Paths
STRING_CATALOG = os.path.join(os.getenv("SRCROOT"), "Giveaway", "Resources", "Localizable.xcstrings")
OUTPUT_DIR = os.path.join(os.getenv("SRCROOT"), "Giveaway", "Resources", "Generated")
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "StringConstants.swift")

# Ensure the output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Check if the String Catalog exists
if not os.path.isfile(STRING_CATALOG):
    print(f"Error: String Catalog not found at {STRING_CATALOG}")
    sys.exit(1)

# Load the String Catalog
with open(STRING_CATALOG, "r") as file:
    catalog = json.load(file)

# Generate the Swift file
with open(OUTPUT_FILE, "w") as file:
    file.write("// Auto-generated from String Catalog\n")
    file.write("// DO NOT EDIT MANUALLY\n\n")
    file.write("import SwiftUI\n\n")
    file.write("enum StringConstants {\n")

    # Process each string
    for key, value in catalog["strings"].items():
        localizations = value.get("localizations", {})
        if not localizations:
            continue

        # Add comment with locale titles
        file.write(f"    // Localizations for '{key}':\n")
        for locale, loc_value in localizations.items():
            file.write(f"    // - {locale}: {loc_value.get('stringUnit', {}).get('value', '')}\n")

        # Check if the string contains parameters (e.g., "%@")
        has_parameters = any("%@" in loc.get("stringUnit", {}).get("value", "") for loc in localizations.values())

        if has_parameters:
            # Generate a function for parameterized strings
            file.write(f"    static func {key}(_ args: CVarArg...) -> String {{\n")
            file.write(f"        return String(format: NSLocalizedString(\"{key}\", comment: \"\"), arguments: args)\n")
            file.write("    }\n")
        else:
            # Generate a constant for non-parameterized strings
            file.write(f"    static let {key} = LocalizedStringKey(\"{key}\")\n")

    file.write("}\n")

print(f"Generated StringConstants.swift at {OUTPUT_FILE}")