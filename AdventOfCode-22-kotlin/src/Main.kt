import java.io.File
import kotlin.math.absoluteValue
import kotlin.math.max
import kotlin.math.min

data class Position3D(val x: Int, val y: Int, val z: Int)

fun doRangesOverlap(range1: IntRange, range2: IntRange): Boolean {
    return range1.first <= range2.last && range2.first <= range1.last
}

data class Brick(var topEdge: Position3D, var bottomEdge: Position3D, val height: Int = 1) {

    companion object {
        fun fromString(line: String): Brick {
            val edges = line.split("~")
            val edge1 = edges[0].split(",").map { it.toInt() }
            val edge1P = Position3D(edge1[0], edge1[1], edge1[2])
            val edge2 = edges[1].split(",").map { it.toInt() }
            val edge2P = Position3D(edge2[0], edge2[1], edge2[2])
            val height = (edge2P.z - edge1P.z).absoluteValue
            if (edge2P.z > edge1P.z) {
                return Brick(edge2P, edge1P, height)
            } else {
                return Brick(edge1P, edge2P, height)
            }
        }
    }

    fun changeZ(newZ: Int) {
        bottomEdge = Position3D(topEdge.x, topEdge.y, newZ)
        topEdge = Position3D(bottomEdge.x, bottomEdge.y, newZ + height)
    }

    fun isOverlapWith(brick: Brick): Boolean {
        return isOverlapXWith(brick) && isOverlapYWith(brick)
    }

    fun isOverlapXWith(brick: Brick): Boolean {
        val brickLeftX = min(brick.topEdge.x, brick.bottomEdge.x)
        val brickRightX = max(brick.topEdge.x, brick.bottomEdge.x)
        val thisRightX = max(topEdge.x, bottomEdge.x)
        val thisLeftX = min(topEdge.x, bottomEdge.x)
        return doRangesOverlap(thisLeftX..thisRightX, brickLeftX..brickRightX)
    }

    fun isOverlapYWith(brick: Brick): Boolean {
        val brickLeftY = min(brick.topEdge.y, brick.bottomEdge.y)
        val brickRightY = max(brick.topEdge.y, brick.bottomEdge.y)
        val thisRightY = max(topEdge.y, bottomEdge.y)
        val thisLeftY = min(topEdge.y, bottomEdge.y)
        return doRangesOverlap(thisLeftY..thisRightY, brickLeftY..brickRightY)
    }
}

class Snapshot(val bricks: MutableList<Brick>) {

    fun calculateBricksNextPosition() {
        bricks.sortBy { it.bottomEdge.z }
        bricks[0].changeZ(1)
        for (i in 1..bricks.size - 1) {
            val brick = bricks[i]
            for (j in i - 1 downTo 0) {
                val bricksUnder = bricks[j]
                if (brick.isOverlapWith(brick = bricksUnder)) {
                    brick.changeZ(bricksUnder.bottomEdge.z + 1)
                    break
                }
            }
        }
    }

    fun countBricksCanSafelyDisintegrate(): Int {
        bricks.sortBy { it.bottomEdge.z }
        var count = 0
        for (i in 0..bricks.size - 1) {
            val brick = bricks[i]
            val supportedBricks = bricks.filter { it.topEdge.z == brick.bottomEdge.z + 1 && it.isOverlapWith(brick) }
            if (supportedBricks.isEmpty()) {
                count++
                continue
            }
            val possibleSupporters = bricks.filter { it.topEdge.z == brick.topEdge.z }
            if (possibleSupporters.size < 2) {
                continue
            }
            // if [supportedBricksOver] are supported by more than one brick it means that we can remove [brick]
            var numberOfSupporters = 0
            for (possibleSupporter in possibleSupporters) {
                if (supportedBricks.all { it.isOverlapWith(possibleSupporter) }) {
                    numberOfSupporters++
                    if (numberOfSupporters > 1) {
                        count++
                        break
                    }

                }
            }
        }
        return count
    }
}

fun main() {
    val lines: List<String> = File("src/input.txt").readLines()
    val bricks = mutableListOf<Brick>()
    for (line in lines) {
        bricks.add(Brick.fromString(line))
    }
    val snapshot = Snapshot(bricks)
    snapshot.calculateBricksNextPosition()
    val count = snapshot.countBricksCanSafelyDisintegrate()
    println(count)
}