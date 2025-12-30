This is a Bash script that simulates the generation of a B.Sc. in Computer Science academic transcript. It processes core and elective modules across four academic stages, assigns random grades to each module, and ensures that minimum credit requirements are met. It supports an internship option for Stage 3.

-------------------------
FEATURES
-------------------------

- Processes modules for Stages 1 to 4.
- Handles internship (I) or non-internship (NI) pathways in Stage 3.
- Assigns random grades and calculates grade point totals.
- Ensures minimum credit thresholds are met per stage.
- Modular design using *.sh.inc include files for flexibility.

-------------------------
USAGE
-------------------------

Run the script with the following syntax:

    ./transcript_printer.sh <I|NI>

Where:
    I  - Includes internship module (COMP30790) in Stage 3
    NI - Excludes internship module from Stage 3

Example:

    ./transcript_printer.sh I

-------------------------
FILE STRUCTURE
-------------------------

- transcriptprinter.sh     — Main script
- stage1.sh.inc            — Stage 1 core/elective module definitions
- stage2.sh.inc            — Stage 2 module definitions
- stage3.sh.inc            — Stage 3 module definitions (includes internship)
- stage4.sh.inc            — Stage 4 module definitions
- grades.sh.inc            — Grade mappings (letter grade ↔ grade point)
- mincredits.sh.inc        — Minimum credit requirements per stage

Note: All include files must be present in the same directory as the script.

-------------------------
SAMPLE OUTPUT
-------------------------

    Stage 1
    COMP10110 IntroductionToCS 5 A 4
    COMP10220 LogicAndComputation 5 B+ 3
    ...
    Total grade point score = 195.

-------------------------
REQUIREMENTS
-------------------------

- Unix-like shell (e.g. Bash)
- Bash version 4 or higher recommended
