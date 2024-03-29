#!/usr/bin/env python
# encoding: utf-8
"""
genderPredictor.py
Trains a naive bayes gender classifier and classifies a given twitter information file containing a single tweet information (tweet_id\ttweet_usr_id\tuser_name) into gender M/F. The input file is created by running 
"""

from nltk import NaiveBayesClassifier,classify
import USSSALoader
import random
import sys

class genderPredictor():
    
    def getFeatures(self):
        maleNames,femaleNames=self._loadNames()
        
        featureset = list()
        for nameTuple in maleNames:
            features = self._nameFeatures(nameTuple[0])
            featureset.append((features,'M'))
        
        for nameTuple in femaleNames:
            features = self._nameFeatures(nameTuple[0])
            featureset.append((features,'F'))
    
        return featureset
    
    def trainAndTest(self,trainingPercent=0.80):
        featureset = self.getFeatures()
        random.shuffle(featureset)
        
        name_count = len(featureset)
        
        cut_point=int(name_count*trainingPercent)
        
        train_set = featureset[:cut_point]
        test_set  = featureset[cut_point:]
        
        self.train(train_set)
        
        return self.test(test_set)
        
    def classify(self,name):
        feats=self._nameFeatures(name)
        return self.classifier.classify(feats)
        
    def train(self,train_set):
        self.classifier = NaiveBayesClassifier.train(train_set)
        return self.classifier
        
    def test(self,test_set):
       return classify.accuracy(self.classifier,test_set)
        
    def getMostInformativeFeatures(self,n=5):
        return self.classifier.most_informative_features(n)
        
    def _loadNames(self):
        return USSSALoader.getNameList()
        
    def _nameFeatures(self,name):
        name=name.upper()
        return {
            'last_letter': name[-1],
            'last_two' : name[-2:],
            'last_is_vowel' : (name[-1] in 'AEIOUY')
        }

if __name__ == "__main__":
    gp = genderPredictor()
    accuracy=gp.trainAndTest()
    feats=gp.getMostInformativeFeatures(10)
    


    with open(sys.argv[1]) as f:
    	for line in f:
		#print line
		entries = line.split("\t")
		#print entries[2]
		print "%s\t%s\t%s" %(entries[0],entries[1],gp.classify(entries[2]))





     
