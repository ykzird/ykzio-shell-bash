# Ykzio Shell

## Overview
Ykzio Shell is a modular management tool designed to provide an interactive command-line experience using the `gum` library. It is built with Bash scripting and includes features for package management, configuration handling, and logging.

## Features
- **Interactive Menus**: Provides a user-friendly interface for managing system updates and configurations.
- **Package Management**: Automatically checks and installs required packages.
- **Logging**: Logs script activities with support for different log levels (DEBUG, INFO, WARN, ERROR, TRACE).
- **Configuration Management**: Ensures the presence of configuration files and directories.
- **APT Lock Handling**: Waits for APT locks to be released before proceeding with package operations.

## ToDo's
- Improve look and feel off the applcation
- Think of a way to create a one-size-fits-all binary.

## Project Structure
```
Dockerfile
bin/
    ykzio-shell.sh
config/
    config.json
logs/
    debug.log
    <timestamped log files>
modules/
    config.sh
    logging.sh
    menu.sh
    packages.sh
    utils.sh
.env
```

### Key Files
- **bin/ykzio-shell.sh**: Main entry point for the script.
- **modules/**: Contains modular scripts for logging, configuration, menu handling, and utilities.
- **config/config.json**: Stores metadata and update information.
- **.env**: Environment variables for configuration.

## Prerequisites
- **Operating System**: Linux-based (e.g., Ubuntu 22.04).
- **Dependencies**: The following packages are required:
  - `jq`
  - `bash`
  - `coreutils`
  - `grep`
  - `sed`
  - `gawk`

## Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd ykzio-shell
   ```

## Usage
Run the main script:
```bash
./bin/ykzio-shell.sh
```

## Testing
Testing needs to be worked out more to test individual functions, for now however I look to see my scripts working, especially on a fresh machine.
To test the script, here's how I currently do it:
```bash
./run-docker.sh
```
Done! This small script will build the docker image from the `Dockerfile`<br>
and run it afterwards.


### Command-Line Arguments
- `--debug`: Sets the log level to DEBUG.
- `--trace`: Sets the log level to TRACE.

## Logging
Logs are stored in the `logs/` directory. Debug logs are written to `debug.log`, and timestamped logs are created for each session.

## Configuration
The configuration file is located at `config/config.json`. If it does not exist, the script will create it during the first run.

## Development
### Adding New Modules
1. Create a new `.sh` file in the `modules/` directory.
2. Source the new module in `bin/ykzio-shell.sh`.
3. Implement the required functionality.

### Debugging
Use the `--debug` or `--trace` flags to enable detailed logging.

## License
This project is licensed under the MIT License.