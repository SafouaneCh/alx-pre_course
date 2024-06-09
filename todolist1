#!/bin/bash

TODO_DIR="$HOME/.todo"

mkdir -p "$TODO_DIR"

display_help() {
    echo "Usage: $0 [option...] {view|add|remove|show|edit|filter-status|filter-priority|export|import|history|help|alarm}" >&2
    echo
    echo "   -v, --view                  View the list of all tasks"
    echo "   -a, --add                   Add a new task"
    echo "   -r, --remove TASK           Remove a specific task"
    echo "   -s, --show TASK             Show details of a specific task"
    echo "   -e, --edit TASK             Edit a specific task"
    echo "   -f, --filter-status         Filter tasks by their status (e.g., ongoing, completed)"
    echo "   -p, --filter-priority       Filter tasks by their priority (e.g., high, medium, low)"
    echo "   -x, --export                Export all tasks to an archive file"
    echo "   -i, --import                Import tasks from an archive file"
    echo "   -h, --history               Show the modification history of the tasks"
    echo "   -A, --alarm TASK            Activate an alarm for a task"
    echo "   -H, --help                  Display this help message"
    echo
    exit 1
}

Show_List() {
    for task in "$TODO_DIR"/*; do
        echo "Task: $(basename "$task")"
    done
}

Add_Task() {
    n=$(ls "$TODO_DIR" | wc -l)
    task_dir="$TODO_DIR/Task$n"
    mkdir "$task_dir" || exit

    task_file="$task_dir/Task$n.txt"
    touch "$task_file"

    read -p "_ What's your task title: " title
    echo "- Title: $title" >> "$task_file"

    read -p "_ What's the deadline of your task: " deadline
    echo "- Deadline: $deadline" >> "$task_file"

    date=$(date)
    echo "- Added in: $date" >> "$task_file"

    echo "- Status: ongoing" >> "$task_file"

    read -p "_ Who works on this task: " assignees
    echo "- Assignees: $assignees" >> "$task_file"

    read -p "_ What do you need to complete this task: " attachments
    echo "- Attachments: $attachments" >> "$task_file"

    read -p "_ What is the priority of this task (high, medium, low): " priority
    echo "- Priority: $priority" >> "$task_file"

    echo
    read -p "_ Do you wish to add any sub-tasks (y/n): " answer

    case $answer in
        n|N) 
            echo "No sub-tasks added"
            ;;
        y|Y) 
            Add_subTask "$task_dir"
            echo "SubTask added successfully"
            ;;
        *) 
            echo "Incorrect Input"
            ;;
    esac
}

Remove_Task() {
    task="$1"
    if [ -z "$task" ]; then
        read -p "Which task do you want to remove? " task
    fi
    task_path="$TODO_DIR/$task"
    if [ -d "$task_path" ]; then
        rm -rf "$task_path"
        echo "Task '$task' has been removed."
    else 
        echo "No such task in the list."
    fi
}

Add_subTask() {
    local task_dir="$1"
    k=$(ls "$task_dir" | wc -l)
    subtask_file="$task_dir/Sub_Task$k.txt"

    touch "$subtask_file"

    read -p "What's your task title: " title
    echo "- Title: $title" >> "$subtask_file"

    read -p "What's the deadline of your task: " deadline
    echo "- Deadline: $deadline" >> "$subtask_file"

    date=$(date)
    echo "- Added in: $date" >> "$subtask_file"

    read -p "Who works on this task: " assignees
    echo "- Assignees: $assignees" >> "$subtask_file"

    read -p "What do you need to complete this task: " attachments
    echo "- Attachments: $attachments" >> "$subtask_file"

    read -p "Do you wish to add other sub-tasks (y/n): " answer

    case $answer in
        n|N) echo "No other sub-tasks added" ;;
        y|Y) Add_subTask "$task_dir" ;;
        *) echo "Incorrect Input" ;;
    esac
}

Remove_Subtask() {
    task="$1"
    subtask="$2"
    if [ -z "$task" ]; then
        read -p "Which task contains the subtask: " task
    fi
    if [ -z "$subtask" ]; then
        read -p "Which subtask do you want to remove: " subtask
    fi
    subtask_path="$TODO_DIR/$task/$subtask"
    if [ -f "$subtask_path" ]; then
        rm "$subtask_path"
        echo "Subtask '$subtask' removed from task '$task'"
    else
        echo "No such subtask in task '$task'"
    fi
}

Show_Task() {
    task="$1"
    if [ -z "$task" ]; then
        read -p "Which task do you wish to view? " task
    fi
    task_path="$TODO_DIR/$task"
    if [ -d "$task_path" ]; then
        for j in "$task_path"/*; do
            if [[ "$(basename "$j")" == Task* ]]; then
                echo "The main task is:"
                echo
                cat "$j"
                echo
            elif [[ "$(basename "$j")" == Sub* ]]; then
                echo "The sub-tasks are:"
                echo
                cat "$j"
                echo
            fi
        done
    else
        echo "No such task"
    fi
}

Filter_By_Status() {
    read -p "_Enter the status to filter by (ongoing, completed): " status
    echo "Tasks with status '$status':"
    find "$TODO_DIR" -type f -name "*.txt" -exec grep -l "- Status: $status" {} \;
}

Filter_By_Priority() {
    read -p "_Enter the priority to filter by (high, medium, low): " priority
    echo "Tasks with priority '$priority':"
    find "$TODO_DIR" -type f -name "*.txt" -exec grep -l "- Priority: $priority" {} \;
}

Export_Tasks() {
    read -p "Enter the name of the archive (or press Enter to use the default name): " user_archive_name
    if [ -z "$user_archive_name" ]; then
        archive_name="$TODO_DIR/tasks_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    else
        archive_name="$TODO_DIR/${user_archive_name}.tar.gz"
    fi
    tar -cvf "$archive_name" -C "$TODO_DIR" .
    echo "All tasks have been exported to $archive_name"
}

Import_Tasks() {
    read -p "Enter the name of the archive to import tasks from: " archive_name
    if [ -f "$archive_name" ]; then
        tar -xvf "$archive_name" -C "$TODO_DIR"
        echo "Tasks have been imported from $archive_name"
    else
        echo "Archive file $archive_name not found"
    fi
}

Edit_Task() {
    task="$1"
    if [ -z "$task" ]; then
        read -p "Which task do you want to edit? " task
    fi
    task_dir="$TODO_DIR/$task"
    if [ -d "$task_dir" ]; then
        cd "$task_dir"
        task_file="$task_dir/$task.txt"
        if [ -f "$task_file" ]; then
            echo "Editing Task: $task"
            nano "$task_file"
            echo "Task edited successfully!"
            echo "Task edited: $task at $(date)" >> "../modification_history.txt"
        else
            echo "No such task"
        fi
        cd ..
    else
        echo "No such task"
    fi
}

Edit_Subtask() {
    task="$1"
    subtask="$2"
    if [ -z "$task" ]; then
        read -p "Which task contains the subtask you want to edit? " task
    fi
    if [ -z "$subtask" ]; then
        read -p "Which subtask do you want to edit? " subtask
    fi
    if [ -d "$TODO_DIR/$task" ]; then
        if [ -f "$TODO_DIR/$task/$subtask" ]; then
            cd "$TODO_DIR/$task"
            nano "$subtask"
            echo "Subtask edited successfully!"
            echo "Subtask edited: $subtask in task: $task at $(date)" >> "../modification_history.txt"
            cd ..
        else
            echo "No such subtask"
        fi
    else
        echo "No such task"
    fi
}

Show_History() {
    history_file="$TODO_DIR/modification_history.txt"
    if [ -f "$history_file" ]; then
        cat "$history_file"
    else
        echo "No history found"
    fi
}

Alarm_Task() {
    task="$1"
    if [ -z "$task" ]; then
        read -p "Which task do you want to set an alarm for? " task
    fi
    task_path="$TODO_DIR/$task/Task$task.txt"
    if [ -f "$task_path" ]; then
        read -p "Enter the alarm time (e.g., 5 minutes): " alarm_time
        sleep "$alarm_time" && notify-send "Reminder: Task $task is due now!"
        echo "Alarm set for task '$task' at $alarm_time from now."
    else
        echo "No such task"
    fi
}

# Main loop
case "$1" in
    -v|--view)
        Show_List
        ;;
    -a|--add)
        Add_Task
        ;;
    -r|--remove)
        Remove_Task "$2"
        ;;
    -s|--show)
        Show_Task "$2"
        ;;
    -e|--edit)
        Edit_Task "$2"
        ;;
    -f|--filter-status)
        Filter_By_Status
        ;;
    -p|--filter-priority)
        Filter_By_Priority
        ;;
    -x|--export)
        Export_Tasks
        ;;
    -i|--import)
        Import_Tasks
        ;;
    -h|--history)
        Show_History
        ;;
    -A|--alarm)
        Alarm_Task "$2"
        ;;
    -H|--help)
        display_help
        ;;
    --remove-subtask)
        Remove_Subtask "$2" "$3"
        ;;
    --edit-subtask)
        Edit_Subtask "$2" "$3"
        ;;
    *)
        echo "Invalid option. Use -H or --help for help."
        ;;
esac

