import java.io.File
import kotlin.math.max
import kotlin.math.min

data class Position3D(val x: Int, val y: Int, val z: Int)
data class Brick(
    var topEdge: Position3D,
    var bottomEdge: Position3D,
    val layOn: MutableList<Brick>,
    val support: MutableList<Brick>
) {
    companion object {
        fun fromString(line: String): Brick {
            val edges = line.split("~")
            val edge1 = edges[0].split(",").map { it.toInt() }
            val edge1P = Position3D(edge1[0], edge1[1], edge1[2])
            val edge2 = edges[1].split(",").map { it.toInt() }
            val edge2P = Position3D(edge2[0], edge2[1], edge2[2])
            if (edge2P.z > edge1P.z) {
                return Brick(
                    topEdge = edge2P,
                    bottomEdge = edge1P,
                    layOn = mutableListOf(),
                    support = mutableListOf()
                )
            } else {
                return Brick(
                    topEdge = edge1P,
                    bottomEdge = edge2P,
                    layOn = mutableListOf(),
                    support = mutableListOf()
                )
            }
        }
    }

    fun changeZ(newZ: Int) {
        val height = topEdge.z - bottomEdge.z
        bottomEdge = Position3D(bottomEdge.x, bottomEdge.y, newZ)
        topEdge = Position3D(topEdge.x, topEdge.y, newZ + height)
    }

    fun isOverlapWith(brick: Brick): Boolean {
        return max(brick.topEdge.x, topEdge.x) <= min(brick.bottomEdge.x, bottomEdge.x) &&
                max(brick.topEdge.y, topEdge.y) <= min(brick.bottomEdge.y, bottomEdge.y)
    }

    override
    fun toString(): String {
        return "Brick(topEdge=$topEdge, bottomEdge=$bottomEdge, layOnSize=${layOn.size}, supportSize=${support.size})"
    }
}

class Snapshot(val bricks: MutableList<Brick>) {

    fun setBricksNextPosition() {
        bricks.sortBy { it.bottomEdge.z }
        for (i in 1..bricks.size - 1) {
            val brick = bricks[i]
            var newZ = 1
            for (j in i - 1 downTo 0) {
                val bricksUnder = bricks[j]
                if (brick.isOverlapWith(brick = bricksUnder)) {
                    newZ = max(newZ, bricksUnder.topEdge.z + 1)
                }
            }
            brick.changeZ(newZ)
        }
    }

    // 12 index cos nie tak jest
    fun countBricksCanSafelyDisintegrate(): Int {
        bricks.sortBy { it.bottomEdge.z }
        var count = 0
        for (upperBrick in bricks) {
            for (lowerBrick in bricks) {
                if (upperBrick.isOverlapWith(lowerBrick) && upperBrick.bottomEdge.z == lowerBrick.topEdge.z + 1) {
                    upperBrick.layOn.add(lowerBrick)
                    lowerBrick.support.add(upperBrick)
                }
            }
        }
        for (brick in bricks) {
            if (brick.support.all { it.layOn.size > 1 }) {
                count++
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
    snapshot.setBricksNextPosition()
    val count = snapshot.countBricksCanSafelyDisintegrate()
    println(count)
}