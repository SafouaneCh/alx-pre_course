#!/bin/bash


Show_Menu() {
    echo "To-Do List Menu:
          your choices are: 
        1. View: View the To-Do List that you wish to see
        2.1. Add1 : Add a Task to an existing list 
         .2. Add2 : Add a new list and new Tasks
        3. Remove: Remove Task
        4. Show-Task: Show a specific Task
        5. Edit : Edit a specific Task
        6. Filter: Filter by status
        7. Priority: Prioritize Tasks
        9. Alarm: Activate the alarm option
        10. Press 0 : Exit"

    read -p "Your choice: " choice
    Handle_Choice "$choice"
}

Handle_Choice() {
    case $1 in
        View) Show_List ;;
        Add1) Add_Task ;;
        Add2) Add_List ;;
	Show-Task) Show_Task ;;
        0) exit ;;
        *) echo "Invalid choice";;
    esac
}

Show_List() {
    cd "to_do_list "
    echo "Enter the name of the list you wish to view: "
    read name 

    if [ -d "$name" ]; then
        ls "$name"
    else 
        echo "There's no such list in your machine"
    fi
}

Add_Task() {
    echo "_ In which list does your Task exist : "
    read name

    n=$(ls $name| wc -l)
    let n=$n+1
    mkdir "$name/Task$n" || exit
    cd "$name/Task$n"
    touch "Task$n.txt" || exit

    

    echo "_ What's your task title: "
    read title
    echo "- Title: $title" >> Task$n.txt

    echo "_ What's the deadline of your task: "
    read deadline
    echo "- Deadline: $deadline" >> Task$n.txt

    date=$(date)
    echo "- Added in: $date" >> Task$n.txt

    echo "- Status: ongoing" >> Task$n.txt

    echo "_ Who works on this task: "
    read assignees
    echo "- Assignees: $assignees" >> Task$n.txt

    echo "_ What do you need to complete this task: "
    read attachments
    echo "- Attachments: $attachments" >> Task$n.txt

    echo "_ Do you wish to add any sub-tasks (y/n): "
    read answer

    case $answer in
        n|N) 
            echo "No sub-tasks added"
            ;;
        y|Y) 
            Add_subTask "Task$n"
            echo "SubTask added successfully"
            ;;
        *) 
            echo "Incorrect Input"
            ;;
    esac
}

Add_List() {
	n=$(ls  | wc -l)
    let n=$n-1
    mkdir "List$n" || exit
    echo "List$n created successfully"
}



Add_subTask() {
    local list="$1"

    k=$(ls "$list" | wc -l)

    cd "$list"
    touch "Sub_Task$k.txt"

    read -p "What's your task title: " title
    echo "- Title: $title" >> "Sub_Task$k.txt"

    read -p "What's the deadline of your task: " deadline
    echo "- Deadline: $deadline" >> "Sub_Task$k.txt"

    date=$(date)
    echo "- Added in: $date" >> "Sub_Task$k.txt"

    read -p "Who works on this task: " assignees
    echo "- Assignees: $assignees" >> "Sub_Task$k.txt"

    read -p "What do you need to complete this task: " attachments
    echo "- Attachments: $attachments" >> "Sub_Task$k.txt"

    read -p "Do you wish to add other sub-tasks (y/n): " answer

    case $answer in
        n|N) echo "No other sub-tasks added" ;;
        y|Y) Add_subTask "$list" ;;
        *) echo "Incorrect Input" ;;
    esac
}

Show_Task(){
	
	echo " In what list is your task : "
	read list
        echo "Which task exactly : "
	read Task
        for j in $(ls "$list/$Task" ); do
        if [[ "$j" == Task* ]]; then
            echo "The main task is : "
            echo -e
            cat "$list/$Task/$j"
            echo -e
        elif [[ "$j" == Sub* ]]; then
            echo "The sub tasks are : "
            echo -e
            cat "$list/$Task/$j"
            echo -e
        fi
    done
}


# Keep showing the menu until the user exits
while true; do
    
    if [[ $choice == 0 ]]; then 
	    exit 
    fi
    Show_Menu
done
