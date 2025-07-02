#!/bin/bash

# Name: Abdus'Samad Bhadmus

# Description: This program produces a transcript for a B.Sc. in Computer 
#              Science. It includes modules from four stages with randomly  
#              assigned grades, ensuring minimum credit requirements are 
#              met. It handles an internship option (I or NI) for stage 3.

# Usage: ./transcript_printer.sh <I|NI>
#        I for internship in stage 3
#        NI for no internship in stage 3

# Sources the necessary include files to load necessary data
source ./stage1.sh.inc
source ./stage2.sh.inc
source ./stage3.sh.inc
source ./stage4.sh.inc
source ./grades.sh.inc
source ./mincredits.sh.inc

# Checks for valid command-line arguments
if [ $# -eq 0 ] || [ "$1" == "--help" ]; then
    echo "Correct usage: bsctranscript.sh <I|NI>"
    echo "I for internship in stage 3"
    echo "NI for no internship in stage 3"
    exit 0
elif [ $# -ne 1 ] || [[ "$1" != "I" && "$1" != "NI" ]]; then
    echo "Error: Invalid arguments."
    echo "Correct usage: bsctranscript.sh <I|NI>"
    exit 1
fi

option=$1
total_gp=0

# Function which processes each stage
process_stage() {
    local stage=$1
    local option=$2
    echo "Stage $stage"

    # Set core and elective arrays based on stage
    case $stage in
        1)
            core=("${stage1core[@]}")
            elective=("${stage1elective[@]}")
            ;;
        2)
            core=("${stage2core[@]}")
            elective=("${stage2elective[@]}")
            ;;
        3)
            core=("${stage3core[@]}")
            elective=("${stage3elective[@]}")
            ;;
        4)
            core=("${stage4core[@]}")
            elective=("${stage4elective[@]}")
            ;;
    esac

    num_core=$((${#core[@]}/3))
    num_elective=$((${#elective[@]}/3))
    total_credits=0

    # Process core modules by iterating over all core modules for the current stage
    # Loop through all core modules for the current stage
    for i in $(seq 0 $((num_core-1))); do
        # Extract module details (code, name, credits) from the core array
        code=${core[$((i*3))]}
        name=${core[$((i*3+1))]}
        credits=${core[$((i*3+2))]}

        # Assign a random grade and grade point from the grades array
        random_grade_index=$((RANDOM % 5))
        grade=${grades[$((random_grade_index*2))]}
        gp=${grades[$((random_grade_index*2+1))]}

        # Print the module details in the required format
        echo "$code $name $credits $grade $gp"

        # Update running totals for grade points and credits
        total_gp=$((total_gp + gp))
        total_credits=$((total_credits + credits))
    done

    # Check if the current stage is Stage 3 and the internship option (I) is specified
    if [ $stage -eq 3 ] && [ "$option" == "I" ]; then
        # Loop through elective modules to find the internship (COMP30790)
        for i in $(seq 0 $((num_elective-1))); do
            if [ "${elective[$((i*3))]}" == "COMP30790" ]; then
                # Extract internship module details
                code=${elective[$((i*3))]}
                name=${elective[$((i*3+1))]}
                credits=${elective[$((i*3+2))]}

                # Assign a random grade and grade point
                random_grade_index=$((RANDOM % 5))
                grade=${grades[$((random_grade_index*2))]}
                gp=${grades[$((random_grade_index*2+1))]}

                # Print internship module details
                echo "$code $name $credits $grade $gp"

                # Update totals and store internship index
                total_gp=$((total_gp + gp))
                total_credits=$((total_credits + credits))
                internship_index=$i

                # Exit loop after processing internship
                break
            fi
        done
    fi

    # Set available electives
    available=()
    for i in $(seq 0 $((num_elective-1))); do
        if [ $stage -ne 3 ] || [ "$option" != "I" ] || [ $i -ne $internship_index ]; then
            available+=($i)
        fi
    done

    # Select electives until total_credits >= minc[stage-1]
    while [ $total_credits -lt ${minc[$((stage-1))]} ] && [ ${#available[@]} -gt 0 ]; do
        # Randomly select an index from available
        rand_pos=$((RANDOM % ${#available[@]}))
        selected_idx=${available[$rand_pos]}

        # Get module details
        code=${elective[$((selected_idx*3))]}
        name=${elective[$((selected_idx*3+1))]}
        credits=${elective[$((selected_idx*3+2))]}

        # Assign random grade
        random_grade_index=$((RANDOM % 5))
        grade=${grades[$((random_grade_index*2))]}
        gp=${grades[$((random_grade_index*2+1))]}
        
        # Print
        echo "$code $name $credits $grade $gp"

        # Add to totals
        total_gp=$((total_gp + gp))
        total_credits=$((total_credits + credits))

        # Remove selected_idx from available
        new_available=()
        for i in "${available[@]}"; do
            if [ $i -ne $selected_idx ]; then
                new_available+=($i)
            fi
        done
        available=("${new_available[@]}")
    done
}

# Use a loop to call the function to process each stage
for stage in {1..4}; do
    process_stage $stage $option
done

# Print total grade point score
echo "Total grade point score = $total_gp."