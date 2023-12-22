import java.io.File

fun main() {
    val grid = File("src/input.txt").readLines().map { it.split("") }
    val startX = grid.find { it.contains("S") }!!.indexOf("S")
    val startY = grid.indexOf(grid.find { it.contains("S") })
    val answer: MutableSet<Pair<Int, Int>> = mutableSetOf()
    val seen = mutableSetOf(Pair(startY, startX))
    val queue = ArrayDeque<Triple<Int, Int, Int>>()
    queue.add(Triple(startY, startX, 64))

    while (queue.isNotEmpty()) {
        val (y, x, step) = queue.removeFirst()
        if (step % 2 == 0) {
            answer.add(Pair(y, x))
        }
        if (step == 0) {
            continue
        }

        for ((nY, nX) in listOf(
            Pair(y + 1, x),
            Pair(y - 1, x),
            Pair(y, x + 1),
            Pair(y, x - 1)
        )) {
            if (nY < 0 || nY >= grid.size || nX < 0 || nX >= grid[0].size || grid[nY][nX] == "#" || seen.contains(
                    Pair(nY, nX)
                )
            ) {
                continue
            }
            seen.add(Pair(nY, nX))
            queue.add(Triple(nY, nX, step - 1))
        }
    }
    println(answer.size)
}