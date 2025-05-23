import React, { useState } from 'react';
import {
  View,
  Text,
  Button,
  Image,
  ScrollView,
  StyleSheet,
  Alert,
  ActivityIndicator,
} from 'react-native';
import { launchCamera, launchImageLibrary } from 'react-native-image-picker';
import { openTransaction, addImage, verify, enroll } from 'react-native-perch-eye';

const FaceCompareScreen = () => {
  const [img1, setImg1] = useState<any>(null);
  const [img2, setImg2] = useState<any>(null);
  const [base64_1, setBase64_1] = useState<string | null>(null);
  const [base64_2, setBase64_2] = useState<string | null>(null);
  const [similarity, setSimilarity] = useState<number | null>(null);
  const [loading, setLoading] = useState(false);

  const cameraOptions = {
    mediaType: 'photo',
    includeBase64: true,
  };

  const handleTakePhoto = (setImg: any, setBase64: any) => {
    launchCamera(cameraOptions, (res) => {
      if (res.didCancel || res.errorCode) return;
      if (res.assets?.length) {
        setImg(res.assets[0]);
        setBase64(res.assets[0].base64 || null);
        setSimilarity(null);
      }
    });
  };

  const handlePickFromGallery = () => {
    launchImageLibrary(
      {
        selectionLimit: 2,
        mediaType: 'photo',
        includeBase64: true,
      },
      (res) => {
        if (res.didCancel || res.errorCode) return;
        const assets = res.assets || [];
        if (assets.length >= 2) {
          setImg1(assets[0]);
          setImg2(assets[1]);
          setBase64_1(assets[0].base64 || null);
          setBase64_2(assets[1].base64 || null);
          setSimilarity(null);
        }
      }
    );
  };

  const handleCompare = async () => {
    if (!base64_1 || !base64_2) {
      Alert.alert('Error', 'Need 2 images');
      return;
    }

    setLoading(true);
    try {
      await openTransaction();
      const r1 = await addImage(base64_1);
      if (r1 !== 'SUCCESS') throw new Error('Add img1 failed');
      const hash = await enroll();

      await openTransaction();
      const r2 = await addImage(base64_2);
      if (r2 !== 'SUCCESS') throw new Error('Add img2 failed');
      const sim = await verify(hash);
      setSimilarity(sim);
    } catch (e) {
      console.error(e);
      Alert.alert('Error', 'Failed');
    } finally {
      setLoading(false);
    }
  };

  const handleReset = () => {
    setImg1(null);
    setImg2(null);
    setBase64_1(null);
    setBase64_2(null);
    setSimilarity(null);
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.header}>👁️ Face Similarity Check</Text>

      <View style={styles.buttonRow}>
        <Button title="📸 First Photo" onPress={() => handleTakePhoto(setImg1, setBase64_1)} />
        <Button title="📸 Second Photo" onPress={() => handleTakePhoto(setImg2, setBase64_2)} />
      </View>

      <Button title="🖼️ Pick 2 from Gallery" onPress={handlePickFromGallery} />

      <View style={styles.imageRow}>
        {img1 && <Image source={{ uri: img1.uri }} style={styles.image} />}
        {img2 && <Image source={{ uri: img2.uri }} style={styles.image} />}
      </View>

      {img1 && img2 && (
        <View style={{ gap: 16 }}>
          <Button title="🔍 Compare Faces" onPress={handleCompare} disabled={loading || similarity !== null} />
          <Button title="🔄 Reset" onPress={handleReset} />
        </View>
      )}

      {loading && <ActivityIndicator size="large" />}

      {similarity !== null && (
        <Text style={styles.similarityText}>Similarity: {(similarity * 100).toFixed(2)}%</Text>
      )}
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 16,
    alignItems: 'center',
  },
  header: {
    fontSize: 22,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  buttonRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: 12,
    marginBottom: 16,
  },
  imageRow: {
    flexDirection: 'row',
    marginVertical: 16,
    gap: 12,
  },
  image: {
    width: 120,
    height: 120,
    borderRadius: 8,
  },
  similarityText: {
    fontSize: 16,
    fontWeight: '500',
    marginTop: 16,
  },
});

export default FaceCompareScreen;
