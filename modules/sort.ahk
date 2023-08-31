; 交换数组两元素的值
swap(arr, i, j) {
    temp := arr[i]
    arr[i] := arr[j]
    arr[j] := temp
}

; 稳定的冒泡排序
listBoxDataSort(listBoxData) {
    ; 对 listBoxData 进行冒泡排序
    i := 0
    while i < listBoxData.Length - 1 {
        flag := false
        j := 0
        while j < listBoxData.Length - 1 - i {
            if listBoxData[j + 1].du > listBoxData[j + 2].du {
                swap(listBoxData, j + 1, j + 2)
                flag := true
            }
            j++
        }
        if not flag
            break
        i++
    }
}

; 提取出名称
map2Items(listBoxData) {
    retArray := Array()
    For value in listBoxData
        retArray.push(value.name)
    return retArray
}
