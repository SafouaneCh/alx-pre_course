#!/bin/bash


Show_Menu() {

    echo "To-Do List Menu:
          your choices are: 
        1. View To-do list
        2. Add a Task 
        3. Remove Task
        4. Show a specific Task
        5. Edit a specific Task
        6. Filter by status
	7. Filter by priority
        8. Activate the alarm option
        0. Exit"

    read -p "Your choice: " choice
    Handle_Choice "$choice"
}

Handle_Choice() {

    case $1 in
        1) Show_List ;;
        2) Add_Task ;;
	4) Show_Task ;;
	6) Filter_By_Status ;;
	7) Filter_By_Priority;;
        0) exit ;;
        *) echo "Invalid choice";;
    esac
}

Show_List() {

   ls 
}

Add_Task() {

    n=$(ls | wc -l)
    let n=$n-1
    mkdir "Task$n" || exit
    cd "Task$n"
    
    touch Task$n.txt    

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
    

    echo "_What is the priority of this task (high, medium, low):"
    read priority
    echo "- Priority: $priority" >> Task$n.txt

    echo -e
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
    cd ..

}


Remove_Task(){

	echo "_Which task do you want to remove ?"
	read task
	if [ -d "$task" ];then
		rm -r "$task"
	else 
		echo "_No such task in the list "

	fi
}


Add_subTask() {

    local list="$1"

    k=$(ls  | wc -l)

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
        y|Y)   Add_subTask "$list" ;;
        *) echo "Incorrect Input" ;;
    esac
    cd..
}


Remove_Subtask(){

    echo "_Which task contains the subtask : "
    read task

    echo "_ Which subtask do you want to remove : "
    read subtask

    if [ -f "$task/$subtask" ]; then
        rm "$task/$subtask"
        echo "Subtask '$subtask' removed from task '$task' "
    else
        echo "No such subtask in task '$task' "
    fi

}


Show_Task(){
  
        echo -e	
        echo "Which task do wish to view : "
	read Task
	for j in $( ls "$Task" )  ; do
        if [[ "$j" == Task* ]]; then
            echo "The main task is : "
            echo -e
            cat "$Task/$j"
            echo -e
        elif [[ "$j" == Sub* ]]; then
            echo "The sub tasks are : "
            echo -e
            cat "$Task/$j"
            echo -e
        fi
    done
}


Filter_By_status(){
	echo "_Enter the status to filter by (ongoing, completed): "
	read status

	echo "Tasks with status '$satus': "
	find . -type f -name "*.txt" -exec grep -l "- Status: $status" {} \; -exec grep "- Type: " {}\;
}


Filter_By_Priority(){
	echo "_Enter the priority to filter by (high, medium, low) :"
	read priority 

	echo "Tasks with priority '$priority': "
	find . -type f -name "*.txt" -exec grep -l "- Priority: $priority"{} \;
	#-l affiche juste le nom des fichiers(tasks) non pas les details du task 
}


# Keep showing the menu until the user exits
while true; do
    
    if [[ $choice == 0 ]]; then 
	    exit 
    fi
    Show_Menu
done
