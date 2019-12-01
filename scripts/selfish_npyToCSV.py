import numpy as np
from scipy import sparse
from scipy.sparse import tril, csr_matrix, triu
import sys
import csv

matrix = np.load(str(sys.argv[1]))
sparseM = triu(sparse.coo_matrix(matrix).tocsr())
matrixO = sparseM.toarray()

with open(str(sys.argv[2]), 'w') as f:
    writer = csv.writer(f)
    writer.writerow(['x', 'y', 'value'])
    for (n, m), val in np.ndenumerate(matrixO):
        if m>=n:
            writer.writerow([n, m, val])



