# README for the robot framework template

## Usage

### Create a virtual environment (optional)

```bash
conda create -n robot python=3.11.0
conda activate robot
```

### Install dependencies

```bash
pip install -r requirements.txt
```

### Run the robot

```bash
robot -d Log -r ${REPORT NAME} -o ${OUTPUT NAME} -l ${LOG NAME} --variable env:${ENV} Testcases/NAME OF FILE.robot
```

## Development guide

For example, to create a new test instance for the login page, create a new file in the Testcases folder and add the running script to robot.yaml.

```bash
    python -m robot -d Log -r ${REPORT NAME} -o ${OUTPUT NAME} -l ${LOG NAME} --variable env:${ENV} Testcases/NAME OF FILE.robot
```

### Suggested directory structure

The directory structure given by the template:

```
├── Keywords
├── Log
├── Page
├── Resourse
│   ├── Env
│   │   └── Uat
│   └── TestData
│       ├── CreateCase
│       ├── Ekyc
│       └── IdCard
├── Schema
│   ├── CaseResponse
│   ├── CreateCaseResponse
│   └── ProprietorResponse
├── Scripts
└── TestCase
```

where
- `Keywords`: Robot Framework keyword files.
- `Log`: This directory stores log files generated during test execution. Logging is essential for debugging and analyzing test runs.
- `Page` : The Page directory typically holds page object definitions.
- `Resource` : This directory stores various resources utilized by your test suite.
- `Env` : This subdirectory contains environment-specific configurations or settings. For example, configurations for different testing environments like UAT (User Acceptance Testing), staging, or production.
- `TestData` : This subdirectory contains test data used in your test cases. It might include input data, expected results, or sample data for various test scenarios.
- `Schema` : This directory holds JSON schema definitions for different types of responses or data structures used in your application. Schemas provide a formal way to define the structure and constraints of JSON data.
- `Scripts` : The Scripts directory typically contains additional scripts or utilities used in your automation workflow. These scripts could include setup/teardown scripts, helper scripts, or custom Python modules used in conjunction with Robot Framework.
- `TestCase` : This directory contains the actual test case files. Test cases are written using the Robot Framework syntax and utilize keywords defined in the Keywords directory. Test cases define the sequence of steps to be executed and assertions to validate the behavior of your application under test.

In addition to these, you can create your own directories (e.g. `bin`, `tmp`). Add these directories to the `PATH` or `PYTHONPATH` section of `robot.yaml` if necessary.

Logs and artifacts are stored in `output` by default - see `robot.yaml` for configuring this.

Learn how to [handle variables and secrets](https://robocorp.com/docs/development-guide/variables-and-secrets/secret-management).

### Additional documentation

See [Robocorp Docs](https://robocorp.com/docs/) for more documentation.
