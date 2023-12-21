import java.io.File
import kotlin.math.max
import kotlin.math.min

fun readInputFile(): List<String> {
    return File("src/input.txt").readLines()
}

fun checkCondition(leftValue: Int, sign: Char, rightValue: Int): Boolean {
    if (sign == '<') {
        return leftValue < rightValue
    } else
        return leftValue > rightValue
}

data class Workflow(val name: String, val instructions: List<Instruction>)
data class Instruction(
    val category: Char? = null,
    val operation: Char? = null,
    val value: Int? = null,
    val result: String
) // either workflow or accepted/failed

data class Range(var min: Int, var max: Int)
data class PossiblePartsRanges(
    val parts: Map<Char, Range> = mapOf(
        'x' to Range(1, 4000),
        'm' to Range(1, 4000),
        'a' to Range(1, 4000),
        's' to Range(1, 4000),
    ),

    ) {
    fun calculateAllPossibleParts(): Long {
        return (parts['x']!!.max - parts['x']!!.min + 1L) *
                (parts['m']!!.max - parts['m']!!.min + 1L) *
                (parts['a']!!.max - parts['a']!!.min + 1L) *
                (parts['s']!!.max - parts['s']!!.min + 1L)
    }

    fun applyInstruction(instruction: Instruction, opposite: Boolean = false) {
        if (instruction.category != null && instruction.operation != null && instruction.value != null && parts[instruction.category] != null) {
            val shift: Int = if (opposite) 1 else 0
            if ((instruction.operation == '<') != opposite) {
                parts[instruction.category]!!.min = max(instruction.value + shift, parts[instruction.category]!!.min)
            } else {
                parts[instruction.category]!!.max = min(instruction.value - shift, parts[instruction.category]!!.max)
            }
        }
    }
}

fun findPossiblePartsRanges(
    workflows: List<Workflow>,
    possiblePartsRanges: PossiblePartsRanges,
    currentWorkflow: Workflow,
    startIndex: Int,
) {
    possiblePartsRanges.applyInstruction(currentWorkflow.instructions[startIndex], true)
    for (i in startIndex - 1 downTo 0) {
        possiblePartsRanges.applyInstruction(currentWorkflow.instructions[i])
    }
    // find callback workflow
    val callbackWorkflow = workflows.find { it.instructions.any { it.result == currentWorkflow.name } }
    if (callbackWorkflow == null) {
        return
    }
    var nexIndex: Int? = null
    for (i in 0..<callbackWorkflow.instructions.size) {
        if (callbackWorkflow.instructions[i].result == currentWorkflow.name) {
            nexIndex = i
            break
        }
    }
    findPossiblePartsRanges(workflows, possiblePartsRanges, callbackWorkflow, nexIndex!!)
}

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
                    Instruction(category[0], '<', value.toInt(), result)
                } else {
                    val (category, value) = condition.split(">")
                    Instruction(category[0], '>', value.toInt(), result)
                }
            } else {
                Instruction(result = instructionText)
            }

        }.toList()
        workflowsMap.put(workflowKey, Workflow(workflowKey, instructions))
    }

    val machineParts: MutableList<Map<Char, Int>> = mutableListOf()
    for (i in lastWorkflowIndex + 1..lines.size - 1) {
        val line = lines[i]
        machineParts.add(line.substring(1, line.length - 1).split(",").map { part ->
            val (category, value) = part.split("=")
            category[0] to value.toInt()
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
    println("Part1:")
    println(acceptedPartsRatingSum)

    // Part 2
    var allAcceptedVariations = 0L
    for (worflow in workflowsMap.values) {
        var possiblePartsRanges = PossiblePartsRanges()
        for (i in 0..worflow.instructions.size - 1) {
            val firstInstruction = worflow.instructions[i]
            if (firstInstruction.result == "A") {
                findPossiblePartsRanges(workflowsMap.values.toList(), possiblePartsRanges, worflow, i)
                allAcceptedVariations += possiblePartsRanges.calculateAllPossibleParts()
                possiblePartsRanges = PossiblePartsRanges()
            }
        }
    }
    println("Part2:")
    println(allAcceptedVariations)
}