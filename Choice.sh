#!/bin/bash

Show_Menu() {
    echo "To-Do List Menu:
        1. View: View the To-Do List that you wish to see
        2.1.Add1 : Add a Task to an existing list
         .2.Add2 : Add a new list and new Tasks
        3. Remove: Remove Task
        4. Show Task: Show a specific Task
        5. Edit: Edit a specific Task
        6. Filter: Filter by status
        7. Priority: Prioritize Tasks
        8. Allarm: Activate the alarm option
        9. Press 0 : Exit"

    read -p "Your choice: " choice
    Handle_Choice "$choice"
}

Handle_Choice() {
    case $1 in
        1) Show_List ;;
        2) Add_Task ;;
        3) Add_List ;;
        0) exit ;;
        *) echo "Invalid choice";;
    esac

}

Show_List() {
    echo "Enter the name of the list you wish to view: "
    read name 

    if [ -d "/home/kali/TO_DO_LIST/$name" ]; then
        ls "/home/kali/TO_DO_LIST/$name"
    else 
        echo "There's no such list in your machine"
    fi
}

Add_Task() {
    n=$(ls -l /home/kali/TO_DO_LIST | wc -l)
    let n=n-1
    mkdir "/home/kali/TO_DO_LIST/Task$n" || exit
    touch "/home/kali/TO_DO_LIST/Task$n/Task$n.txt" || exit

    echo "_ What's your task title: "
    read title
    echo "- Title: $title" >> "/home/kali/TO_DO_LIST/Task$n/Task$n.txt"

    echo "_ What's the deadline of your task: "
    read deadline
    echo "- Deadline: $deadline" >> "/home/kali/TO_DO_LIST/Task$n/Task$n.txt"

    date=$(date)
    echo "- Added in: $date" >> "/home/kali/TO_DO_LIST/Task$n/Task$n.txt"

    echo "- Status: ongoing" >> "/home/kali/TO_DO_LIST/Task$n/Task$n.txt"

    echo "_ Who works on this task: "
    read assignees
    echo "- Assignees: $assignees" >> "/home/kali/TO_DO_LIST/Task$n/Task$n.txt"

    echo "_ What do you need to complete this task: "
    read attachments
    echo "- Attachments: $attachments" >> "/home/kali/TO_DO_LIST/Task$n/Task$n.txt"

    echo "_ Do you wish to add any sub-tasks (y/n): "
    read answer

    case $answer in
        n|N) 
            echo "No sub-tasks added"
            ;;
        y|Y) 
            ./Add_subTask.sh "Task$n"
            echo "SubTask added successfully"
            ;;
        *) 
            echo "Incorrect Input"
            ;;
    esac
}

Add_List() {
    n=$(ls -l /home/kali/TO_DO_LIST | wc -l)
    let n=n-1
    mkdir "/home/kali/TO_DO_LIST/List$n" || exit
    echo "List$n created successfully"
}

# Keep showing the menu until user exits
while true; do
    Show_Menu
    if [ "$choice" -eq 0 ]; then
        exit
    fi
done

