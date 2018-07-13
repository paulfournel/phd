import random
import copy

class Job:
    def __init__(self, r, d):
        self.r = r
        self.d = d
    def __repr__(self):
        return("\tb (" + str(self.r) + "," + str(self.d) + ")\n")
    
class Batch:
    def __init__(self, job):
        self.jobs = [job]
    def add(self, job):
        self.jobs.append(job)
    def getRelease(self):
        return(max([j.r for j in self.jobs]))
    def getDuration(self):
        return(max([j.d for j in self.jobs]))
    def fits(self, job):
        return(self.getDuration() >= job.d)
    def __repr__(self):
        return("released at: " + str(self.getRelease()) + ", duration: " + str(self.getDuration()) + ", jobs: \n" + str(self.jobs))
    
class Schedule:
    def __init__(self):
        self.batches = []
    def prepend(self, batch):
        self.batches.insert(0, batch)
    def makespan(self):
        self.batches.sort(key=lambda x: x.getRelease())
        makespan = 0
        for b in self.batches:
            if(b.getRelease() >= makespan):
                makespan = b.getRelease() + b.getDuration()
            else:
                makespan = makespan + b.getDuration()
        return(makespan)
    def __repr__(self):
        return("makespan: " + str(self.makespan()) + " \n" + str(self.batches))
        
def randomJobs(n):
    arrivals = [random.random() for i in range(1,n)]
    durations = [random.random()/20 for i in range(1,n)]
    arrivals.sort() 
    return([Job(arrivals[i],durations[i]) for i in range(0, len(durations))])

def greedy_n(jobs):
    schedule = Schedule()
    for job in jobs:
        didNotAddBatch = True
        for b in schedule.batches:
            if(didNotAddBatch and b.fits(job)):
                b.add(job)
                didNotAddBatch = False
        if(didNotAddBatch):
            schedule.prepend(Batch(job))
    return(schedule)

def greedy_n_2(jobs):
    schedule = Schedule()
    for job in jobs:
        didNotAddBatch = True
        for b in schedule.batches:
            if(didNotAddBatch and b.fits(job)):
                b.add(job)
                didNotAddBatch = False
        if(didNotAddBatch):
            withNewbatch = copy.deepcopy(schedule)
            withNewbatch.prepend(Batch(job))

            options = []
            for b in schedule.batches:
                options.append(copy.deepcopy(schedule))

            for i in range(0, len(options)):
                options[i].batches[i].add(job)
            options.append(withNewbatch)

            idx = min(range(len(options)), key=lambda i: options[i].makespan())

            schedule = options[idx]
    return(schedule)

n = 100

jobs = randomJobs(n)
jobs.reverse()

greedy_n(jobs).makespan()

greedy_n_2(jobs).makespan()
