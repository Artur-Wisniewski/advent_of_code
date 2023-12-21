import java.io.File

fun readInputFile(): List<String> {
    return File("src/input.txt").readLines()
}

fun checkCondition(leftValue: Int, sign: Char, rightValue: Int): Boolean {
    if (sign == '<') {
        return leftValue < rightValue
    } else
        return leftValue > rightValue
}

data class Workflow(val instructions: List<Instruction>)
data class Instruction(
    val category: String? = null,
    val operation: Char? = null,
    val value: Int? = null,
    val result: String
) // either workflow or accepted/failed

fun main() {
    val lines = readInputFile()
    val workflowsMap = mutableMapOf<String, Workflow>()
    var lastWorkflowIndex = 0
    for (i in 0..lines.size) {
        val line = lines[i]
        if (line.isEmpty()) {
            lastWorkflowIndex = i
            break
        }
        val (workflowKey, instructionsText) = line.substring(0, line.length - 1).split("{")
        val workflowInstructions = instructionsText.split(",")
        val instructions = workflowInstructions.map { instructionText ->
            if (instructionText.contains(':')) {
                val (condition, result) = instructionText.split(":")
                if (condition.contains("<")) {
                    val (category, value) = condition.split("<")
                    Instruction(category, '<', value.toInt(), result)
                } else {
                    val (category, value) = condition.split(">")
                    Instruction(category, '>', value.toInt(), result)
                }
            } else {
                Instruction(result = instructionText)
            }

        }.toList()
        workflowsMap.put(workflowKey, Workflow(instructions))
    }

    val machineParts: MutableList<Map<String, Int>> = mutableListOf()
    for (i in lastWorkflowIndex + 1..lines.size - 1) {
        val line = lines[i]
        machineParts.add(line.substring(1, line.length - 1).split(",").map { part ->
            val (category, value) = part.split("=")
            category to value.toInt()
        }.toMap())
    }

    var acceptedPartsRatingSum = 0
    for (machinePart in machineParts) {
        var currentWorkflow = workflowsMap["in"]!!
        var nextWorkflow: Workflow? = currentWorkflow
        while (true) {
            for (instruction in currentWorkflow.instructions) {
                if (instruction.category == null || checkCondition(
                        machinePart[instruction.category]!!,
                        instruction.operation!!,
                        instruction.value!!
                    )
                ) {
                    if (instruction.result == "A") {
                        acceptedPartsRatingSum += machinePart.values.sum()
                        break
                    } else if (instruction.result != "R") {
                        nextWorkflow = workflowsMap[instruction.result]!!
                    }
                    break
                }
            }
            if (nextWorkflow == currentWorkflow) {
                break
            }
            currentWorkflow = nextWorkflow!!
        }
    }
    println(acceptedPartsRatingSum)
}