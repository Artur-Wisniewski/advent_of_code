import java.io.File

data class NodePath(val node: Node, val distance: Int)

enum class Category {
    START,
    CONNECTION,
    END
}

data class Node(
    val connections: MutableSet<NodePath> = mutableSetOf(),
    val category: Category = Category.CONNECTION,
    val position: Position
)

data class Position(val x: Int, val y: Int)

fun mapGraph(grid: List<CharArray>, startPosition: Position, endPosition: Position): Node {
    var currentNode = Node(category = Category.START, position = startPosition)
    val startNode = currentNode
    var currentPosition = startPosition
    var distanceCount = 1
    val nodesToCheck = ArrayDeque<Pair<Node, Position>>()
    val allNodes = mutableSetOf<Node>(startNode)
    var seenEnd = false
    var previousPosition = startPosition
    do {
        val north = Position(currentPosition.x, currentPosition.y - 1)
        val south = Position(currentPosition.x, currentPosition.y + 1)
        val east = Position(currentPosition.x + 1, currentPosition.y)
        val west = Position(currentPosition.x - 1, currentPosition.y)
        val possibleNextPositions = mutableSetOf<Position>()
        for (nextPosition in listOf(north, south, east, west)) {
            if (nextPosition == previousPosition) {
                continue
            }
            if (currentNode.position == nextPosition) {
                continue
            }
            if (nextPosition.y < 0 || nextPosition.y >= grid.size || nextPosition.x < 0 || nextPosition.x >= grid[0].size) {
                continue
            }
            val nextSign = grid[nextPosition.y][nextPosition.x]
            if (nextSign == '#') {
                continue
            }
            if (nextSign == '>' && nextPosition == west || nextSign == '<' && nextPosition == east || nextSign == '^' && nextPosition == south || nextSign == 'v' && nextPosition == north) {
                continue
            }
            if (nextPosition == endPosition) {
                break
            }
            possibleNextPositions.add(nextPosition)
        }
        if (possibleNextPositions.size == 1) {
            previousPosition = currentPosition
            currentPosition = possibleNextPositions.first()
            distanceCount++
        } else {
            var newNode: Node
            if (allNodes.none { it.position == currentPosition }) {
                if (possibleNextPositions.isEmpty()) {
                    seenEnd = true
                    newNode = Node(position = currentPosition, category = Category.END)
                } else {
                    newNode = Node(position = currentPosition)
                }
                allNodes.add(newNode)
            } else {
                newNode = allNodes.first { it.position == currentPosition }
            }
            if (currentNode.connections.none { it.node.position == newNode.position && it.distance == distanceCount }) {
                currentNode.connections.add(NodePath(newNode, distanceCount))
            }
            for (nextPosition in possibleNextPositions) {
                nodesToCheck.add(Pair(newNode, nextPosition))
            }
            val nextNodeInfo = nodesToCheck.removeFirst()
            previousPosition = currentPosition
            currentNode = nextNodeInfo.first
            currentPosition = nextNodeInfo.second
            distanceCount = 1
        }
    } while (!seenEnd || nodesToCheck.isNotEmpty())
    return startNode
}

fun findLargestPathInGraph(graph: Node): Int {
    val nodesToCheck = ArrayDeque<Pair<Node, Int>>()
    val seenNodes = mutableSetOf<Node>()
    var largestPath = 0
    nodesToCheck.add(Pair(graph, 0))
    do {
        val nextNodeInfo = nodesToCheck.removeFirst()
        val nextNode = nextNodeInfo.first
        val nextDistance = nextNodeInfo.second
        if (nextNode.category == Category.END) {
            if (nextDistance > largestPath) {
                largestPath = nextDistance
            }
        } else {
            for (connection in nextNode.connections) {
                if (seenNodes.contains(connection.node)) {
                    continue
                }
                nodesToCheck.add(Pair(connection.node, nextDistance + connection.distance))
            }
        }
    } while (nodesToCheck.isNotEmpty())
    return largestPath
}

fun main() {
    val lines = File("src/input.txt").readLines()
    val grid: List<CharArray> = lines.map { it.toCharArray() }
    val graphStartingNode = mapGraph(grid, Position(1, 0), Position(grid.size - 2, grid[0].size - 1))
    println("Part1")
    println(findLargestPathInGraph(graphStartingNode))
}